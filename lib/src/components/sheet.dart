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
  final TextEditingController? searchFieldController;
  final String searchFieldHintText;
  final Widget? searchFieldWidget;
  final TenorStyle style;
  final List<TenorTab> tabs;
  final int initialTabIndex;

  const TenorSheet({
    required this.attributionType,
    required this.searchFieldHintText,
    required this.searchFieldWidget,
    required this.style,
    required this.tabs,
    this.initialTabIndex = 1,
    this.searchFieldController,
    super.key,
  });

  @override
  State<TenorSheet> createState() => _TenorSheetState();
}

class _TenorSheetState extends State<TenorSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TenorSheetProvider _sheetProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.initialTabIndex,
      length: widget.tabs.length,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    _sheetProvider = Provider.of<TenorSheetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double _calculateMaxChildSize(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final availableHeight = height - kToolbarHeight;
    final percentage = availableHeight / height;
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    final maxChildSize = _calculateMaxChildSize(context);
    return DraggableScrollableSheet(
      controller: _sheetProvider.scrollController,
      expand: false,
      initialChildSize: maxChildSize,
      maxChildSize: maxChildSize,
      minChildSize: _sheetProvider.minExtent,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          color: widget.style.color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TenorDragHandle(
                style: TenorDragHandleStyle(),
              ),
              TenorTabBar(
                style: widget.style.tabBarStyle,
                tabController: _tabController,
                tabs: widget.tabs.map((tab) => tab.name).toList(),
              ),
              TenorSearchField(
                hintText: widget.searchFieldHintText,
                scrollController: scrollController,
                searchFieldController: widget.searchFieldController,
                searchFieldWidget: widget.searchFieldWidget,
                selectedCategoryStyle: widget.style.selectedCategoryStyle,
                style: widget.style.searchFieldStyle,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: widget.tabs.map((tab) => tab.view).toList(),
                ),
              ),
              if (widget.attributionType == TenorAttributionType.poweredBy)
                TenorAttribution(
                  style: widget.style.attributionStyle,
                ),
            ],
          ),
        );
      },
    );
  }
}
