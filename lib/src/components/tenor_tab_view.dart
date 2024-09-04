import 'package:flutter/material.dart';
import 'package:tenor_dart/tenor_dart.dart';

import 'package:tenor_flutter/src/components/tenor_tab_view_detail.dart';
import 'package:tenor_flutter/src/models/type.dart';

class TenorTabView extends StatelessWidget {
  final ScrollController scrollController;
  final TabController tabController;
  final Function(TenorResult? gif)? onSelected;
  final bool? keepAliveTabView;

  const TenorTabView({
    Key? key,
    required this.scrollController,
    required this.tabController,
    this.showEmojis = true,
    this.showGIFs = true,
    this.showStickers = true,
    this.onSelected,
    this.keepAliveTabView,
  }) : super(key: key);

  final bool showGIFs;
  final bool showStickers;
  final bool showEmojis;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        if (showEmojis)
          TenorTabViewDetail(
            onSelected: onSelected,
            type: TenorType.emoji,
            scrollController: scrollController,
            keepAliveTabView: keepAliveTabView,
          ),
        if (showGIFs)
          TenorTabViewDetail(
            onSelected: onSelected,
            type: TenorType.gifs,
            scrollController: scrollController,
            key: null,
            showCategories: true,
            keepAliveTabView: keepAliveTabView,
          ),
        if (showStickers)
          TenorTabViewDetail(
            onSelected: onSelected,
            type: TenorType.stickers,
            scrollController: scrollController,
            keepAliveTabView: keepAliveTabView,
          ),
      ],
    );
  }
}
