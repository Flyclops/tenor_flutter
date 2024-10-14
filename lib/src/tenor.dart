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
    super.client = const tenor_dart.TenorHttpClient(),
    super.clientKey,
    super.contentFilter = TenorContentFilter.off,
    super.country = 'US',
    super.locale = 'en_US',
    super.networkTimeout = const Duration(seconds: 5),
  });

  /// Shows a bottom sheet modal that allows you to select a Tenor media object for use.
  ///
  /// If you pass in a `searchFieldWidget` you must also pass in a `searchFieldController`. The controller will automatically be disposed of.
  ///
  /// You must have one valid form of [Tenor attribution](https://developers.google.com/tenor/guides/attribution) in order to use this within your app.
  Future<TenorResult?> showAsBottomSheet({
    required BuildContext context,
    TenorAttributionType attributionType = TenorAttributionType.poweredBy,
    Duration debounce = const Duration(milliseconds: 300),
    int initialTabIndex = 1,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    double maxExtent = 0.9,
    double minExtent = 0.7,
    String queryText = '',
    TextEditingController? searchFieldController,
    String searchFieldHintText = 'Search Tenor',
    Widget? searchFieldWidget,
    TenorStyle style = const TenorStyle(),
    List<TenorTab>? tabs,
  }) {
    return showModalBottomSheet<TenorResult>(
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      shape: style.shape,
      useSafeArea: true,
      builder: (context) {
        return DefaultTextStyle.merge(
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
                    keyboardDismissBehavior: keyboardDismissBehavior,
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
                searchFieldHintText: searchFieldHintText,
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
