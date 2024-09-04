// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tenor_flutter/src/providers/tenor_app_bar_provider.dart';
import 'package:tenor_flutter/src/providers/tenor_sheet_provider.dart';
import 'package:tenor_flutter/src/providers/tenor_tab_provider.dart';
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
    switch (_tabProvider.tabType) {
      case 'stickers':
        return 'Stickers';
      case 'emoji':
        return 'Emoji';
      case 'Emoji':
      default:
        return 'GIFs';
    }
  }

  Widget _searchWidget() {
    return Column(
      children: [
        widget.searchFieldWidget ??
            SizedBox(
              height: 40,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextField(
                    // prefixIcon: Icons.search,
                    controller: _textEditingController,
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
                ),
              ),
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
