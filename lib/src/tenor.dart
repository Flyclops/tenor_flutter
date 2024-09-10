import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;

import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/components/tab_view.dart';
import 'package:tenor_flutter/src/components/tab_view_emojis.dart';
import 'package:tenor_flutter/src/components/tab_view_gifs.dart';
import 'package:tenor_flutter/src/components/tab_view_stickers.dart';
import 'package:tenor_flutter/src/models/tab.dart';
import 'package:tenor_flutter/src/providers/providers.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorStyle {
  final TenorAttributionStyle attributionStyle;

  /// Background color of the sheet.
  final Color color;

  final TenorDragHandleStyle dragHandleStyle;

  final TenorTabBarStyle tabBarStyle;

  final TenorTabViewStyle tabViewDetailStyle;

  final TenorSelectedCategoryStyle selectedCategoryStyle;

  const TenorStyle({
    this.attributionStyle = const TenorAttributionStyle(),
    this.color = const Color(0xFFF9F8F2),
    this.dragHandleStyle = const TenorDragHandleStyle(),
    this.tabBarStyle = const TenorTabBarStyle(),
    this.tabViewDetailStyle = const TenorTabViewStyle(),
    this.selectedCategoryStyle = const TenorSelectedCategoryStyle(),
  });
}

class Tenor extends tenor_dart.Tenor {
  const Tenor({
    required super.apiKey,
    super.clientKey,
    super.contentFilter = TenorContentFilter.off,
    super.country = 'US',
    super.locale = 'en_US',
  });

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
    List<TenorTab>? tabs,
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
              tabs: tabs ??
                  [
                    TenorTab(
                      name: 'Emojis',
                      view: TenorViewEmojis(client: this),
                    ),
                    TenorTab(
                      name: 'GIFs',
                      view: TenorViewGifs(client: this),
                    ),
                    TenorTab(
                      name: 'Stickers',
                      view: TenorViewStickers(client: this),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}
