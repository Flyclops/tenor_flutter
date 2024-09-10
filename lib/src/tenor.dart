import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;

import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/providers/providers.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorStyle {
  final TenorAttributionStyle attributionStyle;

  /// Background color of the sheet.
  final Color color;

  final String? fontFamily;

  /// Shape for the sheet.
  final ShapeBorder shape;

  final TenorDragHandleStyle dragHandleStyle;
  final TenorSearchFieldStyle searchFieldStyle;
  final TenorSelectedCategoryStyle selectedCategoryStyle;
  final TenorTabBarStyle tabBarStyle;
  final TenorTabViewStyle tabViewStyle;

  const TenorStyle({
    this.color = const Color(0xFFF9F8F2),
    this.fontFamily,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(8),
      ),
    ),
    this.attributionStyle = const TenorAttributionStyle(),
    this.dragHandleStyle = const TenorDragHandleStyle(),
    this.searchFieldStyle = const TenorSearchFieldStyle(),
    this.selectedCategoryStyle = const TenorSelectedCategoryStyle(),
    this.tabBarStyle = const TenorTabBarStyle(),
    this.tabViewStyle = const TenorTabViewStyle(),
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
    String queryText = '',
    double minExtent = 0.7,
    double maxExtent = 0.9,
    int initialTabIndex = 1,
    Duration debounce = const Duration(milliseconds: 300),
    TenorStyle style = const TenorStyle(),
    List<TenorTab>? tabs,
    TenorAttributionType attributionType = TenorAttributionType.poweredBy,
    TextEditingController? searchFieldController,
    Widget? searchFieldWidget,
  }) {
    return showModalBottomSheet<TenorResult>(
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      shape: style.shape,
      useSafeArea: true,
      builder: (context) {
        return DefaultTextStyle(
          style: TextStyle(
            fontFamily: style.fontFamily,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              // move the sheet up when the keyboard is shown
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => TenorAppBarProvider(
                    queryText,
                    debounce,
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
                  ),
                ),
              ],
              child: TenorSheet(
                attributionType: attributionType,
                initialTabIndex: initialTabIndex,
                searchFieldController: searchFieldController,
                searchFieldWidget: searchFieldWidget,
                style: style,
                tabs: tabs ??
                    [
                      TenorTab(
                        name: 'Emojis',
                        view: TenorViewEmojis(
                          client: this,
                          style: style.tabViewStyle,
                        ),
                      ),
                      TenorTab(
                        name: 'GIFs',
                        view: TenorViewGifs(
                          client: this,
                          style: style.tabViewStyle,
                        ),
                      ),
                      TenorTab(
                        name: 'Stickers',
                        view: TenorViewStickers(
                          client: this,
                          style: style.tabViewStyle,
                        ),
                      ),
                    ],
              ),
            ),
          ),
        );
      },
    );
  }
}
