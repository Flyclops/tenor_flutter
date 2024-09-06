// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/tenor_attribution.dart';

import 'package:tenor_flutter/src/components/tenor_drag_handle.dart';
import 'package:tenor_flutter/src/components/tenor_search_field.dart';
import 'package:tenor_flutter/src/components/tenor_tab_bar.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/src/models/tenor_tab.dart';
import 'package:tenor_flutter/src/providers/sheet_provider.dart';

class TenorSheet extends StatefulWidget {
  final Widget? searchFieldWidget;
  final TextEditingController? searchFieldController;
  final List<TenorTab> tabs;
  final TenorAttributionType attributionType;

  const TenorSheet({
    required this.tabs,
    this.searchFieldWidget,
    this.searchFieldController,
    required this.attributionType,
    Key? key,
  }) : super(key: key);

  @override
  _TenorSheetState createState() => _TenorSheetState();
}

class _TenorSheetState extends State<TenorSheet>
    with SingleTickerProviderStateMixin {
  // Sheet Provider
  late TenorSheetProvider _sheetProvider;

  // Tab Controller
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      initialIndex: 1,
      length: widget.tabs.length,
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    _sheetProvider = Provider.of<TenorSheetProvider>(context, listen: false);

    super.didChangeDependencies();
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
      expand: _sheetProvider.isExpanded,
      initialChildSize: maxChildSize,
      maxChildSize: maxChildSize,
      minChildSize: TenorSheetProvider.minExtent,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          color: const Color(0xFFD2CEC3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TenorDragHandle(),
              TenorTabBar(
                tabController: _tabController,
                tabs: widget.tabs.map((tab) => tab.name).toList(),
              ),
              TenorSearchField(
                scrollController: scrollController,
                searchFieldController: widget.searchFieldController,
                searchFieldWidget: widget.searchFieldWidget,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: widget.tabs.map((tab) => tab.view).toList(),
                ),
              ),
              if (widget.attributionType == TenorAttributionType.poweredBy)
                const TenorAttribution(),
            ],
          ),
        );
      },
    );
  }
}
