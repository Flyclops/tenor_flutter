import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_dart/tenor_dart.dart' as tenor_dart;

import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/src/providers/providers.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

final tenorDefaultAnimationStyle = AnimationStyle(
  duration: const Duration(milliseconds: 250),
  reverseDuration: const Duration(milliseconds: 200),
);

class TenorStyle {
  final AnimationStyle? animationStyle;
  final TenorAttributionStyle attributionStyle;

  /// Background color of the sheet.
  final Color color;
  final TenorDragHandleStyle dragHandleStyle;
  final String? fontFamily;
  final TenorSearchFieldStyle searchFieldStyle;
  final TenorSelectedCategoryStyle selectedCategoryStyle;

  /// Shape for the sheet.
  final ShapeBorder shape;
  final TenorTabBarStyle tabBarStyle;
  final TenorTabViewStyle tabViewStyle;

  const TenorStyle({
    this.animationStyle,
    this.attributionStyle = const TenorAttributionStyle(),
    this.color = const Color(0xFFF9F8F2),
    this.dragHandleStyle = const TenorDragHandleStyle(),
    this.fontFamily,
    this.searchFieldStyle = const TenorSearchFieldStyle(),
    this.selectedCategoryStyle = const TenorSelectedCategoryStyle(),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(8),
      ),
    ),
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
    // Whether to cover the app bar with the bottom sheet.
    bool coverAppBar = false,
    Duration debounce = const Duration(milliseconds: 300),
    double? initialExtent,
    int initialTabIndex = 1,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    double maxExtent = 1,
    double minExtent = 0.7,
    String queryText = '',
    TextEditingController? searchFieldController,
    String searchFieldHintText = 'Search Tenor',
    Widget? searchFieldWidget,
    // A list of target sizes that the showModalBottomSheet should snap to.
    // The [minChildSize] and [maxChildSize] are implicitly included in snap sizes and do not need to be specified here.
    List<double>? snapSizes,
    TenorStyle style = const TenorStyle(),
    List<TenorTab>? tabs,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<TenorResult>(
      clipBehavior: Clip.antiAlias,
      context: context,
      isScrollControlled: true,
      shape: style.shape,
      sheetAnimationStyle: style.animationStyle ?? tenorDefaultAnimationStyle,
      useSafeArea: useSafeArea,
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
                    initialExtent: initialExtent,
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
                coverAppBar: coverAppBar,
                initialTabIndex: initialTabIndex,
                searchFieldController: searchFieldController,
                searchFieldHintText: searchFieldHintText,
                searchFieldWidget: searchFieldWidget,
                snapSizes: snapSizes,
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
