// ignore_for_file: implementation_imports
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenor_flutter/src/models/type.dart';

import 'package:tenor_flutter/src/providers/tenor_tab_provider.dart';

class TenorTabBar extends StatefulWidget {
  final TabController tabController;
  const TenorTabBar({
    Key? key,
    required this.tabController,
    this.showEmojis = true,
    this.showGIFs = true,
    this.showStickers = true,
  }) : super(key: key);

  final bool showEmojis;
  final bool showGIFs;
  final bool showStickers;

  @override
  _TenorTabBarState createState() => _TenorTabBarState();
}

class TabWithType {
  final Tab tab;
  final String type;

  TabWithType({
    required this.tab,
    required this.type,
  });
}

class _TenorTabBarState extends State<TenorTabBar> {
  late TenorTabProvider _tabProvider;
  late List<TabWithType> _tabs;

  @override
  void initState() {
    super.initState();

    // TabProvider
    _tabProvider = Provider.of<TenorTabProvider>(context, listen: false);

    //  Listen Tab Controller
    widget.tabController.addListener(() {
      _setTabType(widget.tabController.index);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setTabType(1);
    });
  }

  @override
  void didChangeDependencies() {
    _tabs = [
      if (widget.showEmojis)
        TabWithType(tab: const Tab(text: 'Emojis'), type: TenorType.emoji),
      if (widget.showGIFs)
        TabWithType(tab: const Tab(text: 'Gifs'), type: TenorType.gifs),
      if (widget.showStickers)
        TabWithType(tab: const Tab(text: 'Stickers'), type: TenorType.stickers),
    ];

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabProvider = Provider.of<TenorTabProvider>(context);

    if (_tabs.length == 1) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFBEB9AC),
          border: Border.all(
            color: const Color(0xFFBEB9AC),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: 30,
          child: TabBar(
            indicatorPadding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.all(0),
            // unselectedLabelStyle: theme.textBody.textStyle(),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // color: theme.colorActive,
            ),
            indicatorWeight: 0,
            // labelColor: theme.primaryTextColor,
            // labelStyle: theme.textBody.textStyle(
            //   fontWeight: FontWeight.bold,
            // ),
            // unselectedLabelColor: theme.primaryTextColor,
            controller: widget.tabController,
            tabs: _tabs.map((e) => e.tab).toList(),
            onTap: _setTabType,
          ),
        ),
      ),
    );
  }

  _setTabType(int pos) {
    // attempt to get the tab
    final newTab = _tabs.firstWhereIndexedOrNull((index, _) => index == pos);
    // do nothing if the tab was not found
    if (newTab == null) return;
    // set the tab type
    _tabProvider.tabType = newTab.type;
  }
}
