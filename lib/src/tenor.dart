import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;
import 'package:tenor_dart/tenor_dart.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/components/tenor_tab_view_detail.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/models/tenor_tab.dart';
import 'package:tenor_flutter/src/models/type.dart';
import 'package:tenor_flutter/src/providers/providers.dart';

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
    super.clientKey,
    super.contentFilter = TenorContentFilter.off,
    super.country = 'US',
    super.locale = 'en_US',
  }) : super();

  Future<TenorResult?> showAsBottomSheet({
    required BuildContext context,
    TenorAttributionType attributionType = TenorAttributionType.searchTenor,
    String queryText = '',
    String searchText = '',
    int debounceTimeInMilliseconds = 350,
    Widget? searchFieldWidget,
    TextEditingController? searchFieldController,
    TenorStyle style = const TenorStyle(),
    List<TenorTab> tabs = const [
      TenorTab(
        name: 'Emojis',
        view: TenorTabViewDetail(
          type: TenorType.emoji,
          keepAliveTabView: true,
          gifWidth: 80,
        ),
      ),
      TenorTab(
        name: 'GIFs',
        view: TenorTabViewDetail(
          type: TenorType.gifs,
          keepAliveTabView: true,
          showCategories: true,
          gifWidth: 200,
        ),
      ),
      TenorTab(
        name: 'Stickers',
        view: TenorTabViewDetail(
          type: TenorType.stickers,
          keepAliveTabView: true,
          gifWidth: 150,
        ),
      ),
    ],
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
        return MultiProvider(
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
              create: (context) => TenorSheetProvider(
                scrollController: DraggableScrollableController(),
              ),
            ),
            ChangeNotifierProvider(
              create: (context) => TenorTabProvider(
                attributionType: attributionType,
                client: this,
                searchText: searchText,
              ),
            ),
          ],
          child: TenorSheet(
            attributionType: attributionType,
            searchFieldController: searchFieldController,
            searchFieldWidget: searchFieldWidget,
            tabs: tabs,
          ),
        );
      },
    );
  }
}
