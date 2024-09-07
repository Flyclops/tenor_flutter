import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;
import 'package:tenor_dart/tenor_dart.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/components/tenor_tab_view.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/models/tenor_tab.dart';
import 'package:tenor_flutter/src/models/type.dart';
import 'package:tenor_flutter/src/providers/providers.dart';

class TenorStyle {
  final TenorAttributionStyle attributionStyle;

  /// Box that displays a single category.
  final TenorCategoryStyle categoryStyle;

  /// Background color of the sheet.
  final Color color;

  final TenorDragHandleStyle dragHandleStyle;

  final TenorTabBarStyle tabBarStyle;

  final TenorTabViewStyle tabViewDetailStyle;

  const TenorStyle({
    this.attributionStyle = const TenorAttributionStyle(),
    this.categoryStyle = const TenorCategoryStyle(),
    this.color = const Color(0xFFF9F8F2),
    this.dragHandleStyle = const TenorDragHandleStyle(),
    this.tabBarStyle = const TenorTabBarStyle(),
    this.tabViewDetailStyle = const TenorTabViewStyle(),
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
    TenorAttributionType attributionType = TenorAttributionType.poweredBy,
    double minExtent = 0.7,
    double maxExtent = 0.9,
    String queryText = '',
    String searchText = '',
    int debounceTimeInMilliseconds = 350,
    TextEditingController? searchFieldController,
    Widget? searchFieldWidget,
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
        return Padding(
          padding: EdgeInsets.only(
            // move the sheet up when the keyboard is shown
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
                create: (context) => TenorSheetProvider(
                  maxExtent: maxExtent,
                  minExtent: minExtent,
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
              style: style,
              tabs: tabs,
            ),
          ),
        );
      },
    );
  }
}
