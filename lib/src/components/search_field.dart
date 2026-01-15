// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tenor_flutter/src/providers/app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/sheet_provider.dart';
import 'package:tenor_flutter/src/utilities/debouncer.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorSelectedCategoryStyle {
  final double height;
  final EdgeInsets padding;
  final Icon? icon;
  final TextStyle textStyle;

  /// The space between icon and text.
  final double spaceBetween;

  const TenorSelectedCategoryStyle({
    this.height = 52,
    this.padding = const EdgeInsets.only(
      left: 14,
      top: 1,
    ),
    this.icon = const Icon(
      Icons.arrow_back_ios_new,
      size: 15,
      color: Color(0xFF8A8A86),
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF8A8A86),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    this.spaceBetween = 8,
  });
}

class TenorSearchFieldStyle {
  final Color fillColor;
  final TextStyle textStyle;
  final TextStyle hintStyle;

  const TenorSearchFieldStyle({
    this.fillColor = Colors.white,
    this.hintStyle = const TextStyle(
      color: Color(0xFF8A8A86),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    this.textStyle = const TextStyle(
      color: Color(0xFF000000),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  });
}

/// If you want to style this just pass in your own via the `searchFieldWidget` parameter.
class TenorSearchField extends StatefulWidget {
  // Scroll Controller
  final ScrollController scrollController;
  final TextEditingController? searchFieldController;
  final Widget? searchFieldWidget;
  final TenorSelectedCategoryStyle selectedCategoryStyle;
  final TenorSearchFieldStyle style;
  final String hintText;
  final AnimationStyle? animationStyle;

  const TenorSearchField({
    super.key,
    required this.hintText,
    required this.scrollController,
    this.animationStyle,
    this.searchFieldController,
    this.searchFieldWidget,
    this.selectedCategoryStyle = const TenorSelectedCategoryStyle(),
    this.style = const TenorSearchFieldStyle(),
  });

  @override
  State<TenorSearchField> createState() => _TenorSearchFieldState();
}

class _TenorSearchFieldState extends State<TenorSearchField> {
  late TenorAppBarProvider _appBarProvider;
  late TenorSheetProvider _sheetProvider;
  late TextEditingController _textEditingController;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    // Focus
    _focus.addListener(() => _onFocusChange(widget.animationStyle));

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);

    // Listen query
    _appBarProvider.addListener(_listenerQuery);

    // Set Texfield Controller
    _textEditingController =
        widget.searchFieldController ??
        TextEditingController(
          text: _appBarProvider.queryText,
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Establish the debouncer
      final debouncer = TenorDebouncer(
        delay: _appBarProvider.debounce,
      );

      // Listener TextField
      _textEditingController.addListener(() {
        debouncer.call(() {
          if (_appBarProvider.queryText != _textEditingController.text) {
            _appBarProvider.queryText = _textEditingController.text;
          }
        });
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sheetProvider = Provider.of<TenorSheetProvider>(context);
    _appBarProvider = Provider.of<TenorAppBarProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focus.dispose();
    _textEditingController.dispose();
    _appBarProvider.removeListener(_listenerQuery);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _appBarProvider.selectedCategory;
    final selectedCategoryStyle = widget.selectedCategoryStyle;
    final queryText = _appBarProvider.queryText;

    if (selectedCategory != null && queryText.isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _appBarProvider.selectedCategory = null,
        child: SizedBox(
          height: selectedCategoryStyle.height,
          child: Padding(
            padding: selectedCategoryStyle.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (selectedCategoryStyle.icon != null) ...[
                  selectedCategoryStyle.icon!,
                  SizedBox(width: selectedCategoryStyle.spaceBetween),
                ],
                Text(
                  selectedCategory.name,
                  style: selectedCategoryStyle.textStyle,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.searchFieldWidget ??
        Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              TextField(
                focusNode: _focus,
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(28, 5, 32, 7),
                  fillColor: widget.style.fillColor,
                  filled: true,
                  hintStyle: widget.style.hintStyle,
                  hintText: widget.hintText,
                  isCollapsed: true,
                  isDense: true,
                ),
                style: widget.style.textStyle,
              ),
              // because prefix icons suck for positioning
              Positioned(
                left: 4,
                child: Icon(
                  Icons.search,
                  color: widget.style.hintStyle.color ?? const Color(0xFF8A8A86),
                  size: 22,
                ),
              ),
              // because suffix icons suck for positioning
              if (_textEditingController.text.isNotEmpty)
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      // make the tap target bigger
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.clear,
                        color: widget.style.hintStyle.color ?? const Color(0xFF8A8A86),
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      // unfocus and clear the search field
                      _focus.unfocus();
                      _textEditingController.clear();
                    },
                  ),
                ),
            ],
          ),
        );
  }

  void _onFocusChange(AnimationStyle? animationStyle) {
    if (_focus.hasFocus) {
      // when they focus the input, maximize viewing space
      _sheetProvider.scrollController.animateTo(
        _sheetProvider.maxExtent,
        duration: animationStyle?.duration ?? tenorDefaultAnimationStyle.duration!,
        curve: animationStyle?.curve ?? Curves.linear,
      );
    }
  }

  // listener query
  void _listenerQuery() {
    // Update only when it's different. IE you tap on a category. Otherwise the cursor will jump to the end.
    if (_textEditingController.text == _appBarProvider.queryText) return;

    _textEditingController.text = _appBarProvider.queryText;
  }
}
