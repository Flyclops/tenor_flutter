import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;
import 'package:tenor_dart/tenor_dart.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/components/tenor_tab_view_detail.dart';
import 'package:tenor_flutter/src/providers/providers.dart';
import 'package:tenor_flutter/src/providers/tenor_style_provider.dart';

class TenorStyle {
  final Color? tabColor;
  final Color? textSelectedColor;
  final Color? textUnselectedColor;

  /// Box that displays a single category.
  final TenorCategoryStyle? categoryStyle;

  final TenorTabViewDetailStyle? tabViewDetailStyle;

  const TenorStyle({
    this.tabColor,
    this.textSelectedColor,
    this.textUnselectedColor,
    this.categoryStyle,
    this.tabViewDetailStyle,
  });
}

class Tenor extends tenor_dart.Tenor {
  Tenor({
    required super.apiKey,
    super.locale = 'en_US',
  }) : super();

  Future<TenorResult?> showAsBottomSheet({
    required BuildContext context,
    String rating = 'g',
    String randomID = '',
    String queryText = '',
    bool showGIFs = true,
    String searchText = '',
    bool showStickers = true,
    bool showEmojis = true,
    Color? tabColor,
    Color? textSelectedColor,
    Color? textUnselectedColor,
    int debounceTimeInMilliseconds = 350,
    Widget? searchFieldWidget,
    TextEditingController? searchFieldController,
    TenorStyle style = const TenorStyle(),

    /// Whether to keep the tab content alive when swiping tabs.
    bool keepAliveTabView = true,
  }) {
    return showModalBottomSheet<TenorResult>(
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => TenorAppBarProvider(
                  queryText,
                  debounceTimeInMilliseconds,
                ),
              ),
              ChangeNotifierProvider(
                create: (context) => TenorStyleProvider(style: style),
              ),
              ChangeNotifierProvider(
                create: (context) => TenorSheetProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => TenorTabProvider(
                  apiKey: apiKey,
                  randomID: randomID,
                  searchText: searchText,
                  rating: rating,
                  lang: locale,
                ),
              ),
            ],
            child: TenorSheet(
              showGIFs: showGIFs,
              showStickers: showStickers,
              showEmojis: showEmojis,
              searchFieldWidget: searchFieldWidget,
              searchFieldController: searchFieldController,
              keepAliveTabView: keepAliveTabView,
            ),
          ),
        );
      },
    );
  }
}
