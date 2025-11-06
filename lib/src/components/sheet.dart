// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/attribution.dart';

import 'package:tenor_flutter/src/components/drag_handle.dart';
import 'package:tenor_flutter/src/components/search_field.dart';
import 'package:tenor_flutter/src/components/tab_bar.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/models/tab.dart';
import 'package:tenor_flutter/src/providers/providers.dart';
import 'package:tenor_flutter/src/tenor.dart';

class TenorSheet extends StatefulWidget {
  final TenorAttributionType attributionType;
  final bool coverAppBar;
  final int initialTabIndex;
  final TextEditingController? searchFieldController;
  final String searchFieldHintText;
  final Widget? searchFieldWidget;
  final TenorStyle style;
  final List<double>? snapSizes;
  final List<TenorTab> tabs;

  const TenorSheet({
    required this.attributionType,
    required this.coverAppBar,
    required this.searchFieldHintText,
    required this.searchFieldWidget,
    required this.style,
    required this.tabs,
    this.initialTabIndex = 1,
    this.searchFieldController,
    this.snapSizes,
    super.key,
  });

  @override
  State<TenorSheet> createState() => _TenorSheetState();
}

class _TenorSheetState extends State<TenorSheet>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TenorSheetProvider sheetProvider;
  late TenorTabProvider tabProvider;
  late final bool canShowTabs;

  @override
  void initState() {
    super.initState();

    tabProvider = Provider.of<TenorTabProvider>(context, listen: false);

    canShowTabs = widget.tabs.length > 1;
    if (canShowTabs) {
      tabController = TabController(
        initialIndex: widget.initialTabIndex,
        length: widget.tabs.length,
        vsync: this,
      );

      // Listen to the animation so it's much
      // more responsive and does not feel laggy
      tabController.animation?.addListener(() {
        // default is the current index
        int index = tabController.index;
        // calculate which tab we're sliding towards
        if (tabController.offset < 0) {
          // if sliding left, subtract
          index = tabController.index - 1;
        } else if (tabController.offset > 0) {
          // if sliding right, add
          index = tabController.index + 1;
        }
        // don't do anything if out of bounds
        if (index < 0 || index >= widget.tabs.length) return;
        // only update if changed
        if (tabProvider.selectedTab != widget.tabs[index]) {
          tabProvider.selectedTab = widget.tabs[index];
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    sheetProvider = Provider.of<TenorSheetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (canShowTabs) {
      tabController.dispose();
    }
    super.dispose();
  }

  double _calculateMaxChildSize(BuildContext context) {
    if (widget.coverAppBar) return sheetProvider.maxExtent;

    final height = MediaQuery.of(context).size.height;
    final availableHeight = height - kToolbarHeight;
    final percentage = availableHeight / height;
    // only use the percentage if the maxExtent would cover the AppBar
    return sheetProvider.maxExtent < percentage
        ? sheetProvider.maxExtent
        : percentage;
  }

  @override
  Widget build(BuildContext context) {
    final maxChildSize = _calculateMaxChildSize(context);
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        // Fix a weird bug where the sheet doesn't snap to the minExtent
        // Ends in something like 0.5000000000000001 instead of 0.5
        final extent =
            double.parse(notification.extent.toStringAsPrecision(15));
        if (extent == sheetProvider.minExtent) {
          sheetProvider.scrollController.jumpTo(sheetProvider.minExtent);
        }
        return false;
      },
      child: DraggableScrollableSheet(
        controller: sheetProvider.scrollController,
        expand: false,
        // just in case we calculate a smaller maxChildSize than initialChildSize
        initialChildSize: sheetProvider.initialExtent > maxChildSize
            ? maxChildSize
            : sheetProvider.initialExtent,
        maxChildSize: maxChildSize,
        minChildSize: sheetProvider.minExtent > maxChildSize
            ? maxChildSize
            : sheetProvider.minExtent,
        snap: true,
        snapSizes: widget.snapSizes,
        builder: (context, scrollController) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: Container(
                  height: constraints.maxHeight,
                  color: widget.style.color,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TenorDragHandle(
                        style: TenorDragHandleStyle(),
                      ),
                      if (canShowTabs)
                        TenorTabBar(
                          style: widget.style.tabBarStyle,
                          tabController: tabController,
                          tabs: widget.tabs.map((tab) => tab.name).toList(),
                        ),
                      TenorSearchField(
                        animationStyle: widget.style.animationStyle,
                        hintText: widget.searchFieldHintText,
                        scrollController: scrollController,
                        searchFieldController: widget.searchFieldController,
                        searchFieldWidget: widget.searchFieldWidget,
                        selectedCategoryStyle:
                            widget.style.selectedCategoryStyle,
                        style: widget.style.searchFieldStyle,
                      ),
                      Expanded(
                        child: (canShowTabs)
                            ? TabBarView(
                                controller: tabController,
                                children: widget.tabs
                                    .map(
                                      (tab) => MultiProvider(
                                        providers: [
                                          Provider<BoxConstraints>(
                                            create: (context) => constraints,
                                          ),
                                          Provider<TenorTab>(
                                            create: (context) => tab,
                                          ),
                                        ],
                                        child: tab.view,
                                      ),
                                    )
                                    .toList(),
                              )
                            : widget.tabs.first.view,
                      ),
                      if (widget.attributionType ==
                          TenorAttributionType.poweredBy)
                        TenorAttribution(
                          style: widget.style.attributionStyle,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
