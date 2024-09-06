// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tenor_flutter/src/providers/app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/sheet_provider.dart';
import 'package:tenor_flutter/src/providers/tab_provider.dart';
import 'package:tenor_flutter/src/tools/debouncer.dart';

class TenorSearchField extends StatefulWidget {
  // Scroll Controller
  final ScrollController scrollController;
  final Widget? searchFieldWidget;
  final TextEditingController? searchFieldController;

  const TenorSearchField({
    Key? key,
    required this.scrollController,
    this.searchFieldWidget,
    this.searchFieldController,
  }) : super(key: key);

  @override
  _TenorSearchFieldState createState() => _TenorSearchFieldState();
}

class _TenorSearchFieldState extends State<TenorSearchField> {
  late TenorTabProvider _tabProvider;
  late TenorAppBarProvider _appBarProvider;
  late TenorSheetProvider _sheetProvider;
  late TextEditingController _textEditingController;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    // Focus
    _focus.addListener(_focusListener);

    // AppBar Provider
    _appBarProvider = Provider.of<TenorAppBarProvider>(context, listen: false);

    // Listen query
    _appBarProvider.addListener(_listenerQuery);

    // Set Texfield Controller
    _textEditingController = widget.searchFieldController ??
        TextEditingController(
          text: _appBarProvider.queryText,
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Establish the debouncer
      final _debouncer = Debouncer(
        delay: Duration(
          milliseconds: _appBarProvider.debounceTimeInMilliseconds,
        ),
      );

      // Listener TextField
      _textEditingController.addListener(() {
        _debouncer.call(() {
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
    // Providers
    _tabProvider = Provider.of<TenorTabProvider>(context);
    _sheetProvider = Provider.of<TenorSheetProvider>(context);
    _appBarProvider = Provider.of<TenorAppBarProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focus.dispose();
    _appBarProvider.removeListener(_listenerQuery);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 10,
      ),
      child: _searchWidget(),
    );
  }

  String getHintText() {
    return 'GIFs';
    // switch (_tabProvider.tabType) {
    //   case 'stickers':
    //     return 'Stickers';
    //   case 'emoji':
    //     return 'Emoji';
    //   case 'Emoji':
    //   default:
    //     return 'GIFs';
    // }
  }

  Widget _searchWidget() {
    return widget.searchFieldWidget ??
        Stack(
          alignment: Alignment.center,
          children: [
            TextField(
              cursorHeight: 18,
              // expands: true,
              // prefixIcon: Icons.search,
              controller: _textEditingController,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.fromLTRB(28, 10, 32, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                isCollapsed: true,
                fillColor: Colors.white,
                hintText: 'Search Tenor',
                // hintStyle: widget._textStyle?.copyWith(
                //       color: theme.secondaryTextColor,
                //     ) ??
                //     style.fontStyle.textStyle(
                //       color: theme.secondaryTextColor,
                //     ),
              ),
              // hintText: getHintText(),
              // textStyle: theme.chatInputStyle.textStyle,
              // style: theme.textFormFieldStyle.copyWith(
              //   boxPadding: const EdgeInsets.only(
              //     top: 6,
              //     bottom: 6,
              //     left: 9,
              //     right: 24 + 9,
              //   ),
              // ),
            ),
            const Positioned(
              left: 4,
              child: Icon(
                Icons.search,
                color: Color(0xFF8A8A86),
                size: 22,
              ),
            ),
            if (_textEditingController.text.isNotEmpty)
              Positioned(
                child: GestureDetector(
                  child: const Padding(
                    child: Icon(
                      Icons.clear,
                      color: Color(0xFF000000),
                      size: 20,
                    ),
                    // make the tap target bigger
                    padding: EdgeInsets.all(8),
                  ),
                  onTap: () {
                    // unfocus and clear the search field
                    FocusScope.of(context).unfocus();
                    _textEditingController.clear();
                  },
                ),
                right: 0,
              ),
          ],
        );
  }

  void _focusListener() {
    // Set to max extent height if Textfield has focus

    if (_focus.hasFocus &&
        _sheetProvider.initialExtent == TenorSheetProvider.minExtent) {
      _sheetProvider.initialExtent = TenorSheetProvider.maxExtent;
    }
  }

  // listener query
  void _listenerQuery() {
    _textEditingController.text = _appBarProvider.queryText;
  }
}
