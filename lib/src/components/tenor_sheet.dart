// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/components/tenor_attribution.dart';

import 'package:tenor_flutter/src/components/tenor_drag_handle.dart';
import 'package:tenor_flutter/src/components/tenor_search_field.dart';
import 'package:tenor_flutter/src/components/tenor_tab_bar.dart';
import 'package:tenor_flutter/src/components/tenor_tab_view.dart';
import 'package:tenor_flutter/src/providers/tenor_sheet_provider.dart';

class TenorSheet extends StatefulWidget {
  final bool _showEmojis;
  final bool _showGIFs;
  final bool _showStickers;
  final Widget? searchFieldWidget;
  final TextEditingController? searchFieldController;
  final bool? keepAliveTabView;

  const TenorSheet({
    bool showEmojis = true,
    bool showGIFs = true,
    bool showStickers = true,
    this.searchFieldWidget,
    this.searchFieldController,
    this.keepAliveTabView,
    Key? key,
  })  : _showEmojis = showEmojis,
        _showGIFs = showGIFs,
        _showStickers = showStickers,
        super(key: key);

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
      length: [
        widget._showEmojis,
        widget._showGIFs,
        widget._showStickers,
      ].where((isShown) => isShown).length,
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
      snap: true,
      expand: _sheetProvider.isExpanded,
      minChildSize: TenorSheetProvider.minExtent,
      maxChildSize: maxChildSize,
      initialChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Container(
          color: const Color(0xFFD2CEC3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TenorDragHandle(),
              TenorTabBar(
                tabController: _tabController,
                showGIFs: widget._showGIFs,
                showStickers: widget._showStickers,
                showEmojis: widget._showEmojis,
              ),
              TenorSearchField(
                scrollController: scrollController,
                searchFieldController: widget.searchFieldController,
                searchFieldWidget: widget.searchFieldWidget,
              ),
              Expanded(
                child: TenorTabView(
                  keepAliveTabView: widget.keepAliveTabView,
                  tabController: _tabController,
                  scrollController: scrollController,
                  showGIFs: widget._showGIFs,
                  showStickers: widget._showStickers,
                  showEmojis: widget._showEmojis,
                ),
              ),
              const TenorAttribution(),
            ],
          ),
        );
      },
    );
  }
}
