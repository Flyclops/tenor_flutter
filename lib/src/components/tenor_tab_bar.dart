import 'package:flutter/material.dart';

class TenorTabBarStyle {
  final BoxDecoration indicator;
  final TabBarIndicatorSize indicatorSize;
  final Color labelColor;
  final TextStyle labelStyle;
  final Color unselectedLabelColor;
  final TextStyle unselectedLabelStyle;

  const TenorTabBarStyle({
    this.indicator = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Color(0xFFFECD4E),
    ),
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.labelColor = const Color(0xFF3B3B3B),
    this.labelStyle = const TextStyle(
      decoration: TextDecoration.none,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.unselectedLabelColor = const Color(0xFF3B3B3B),
    this.unselectedLabelStyle = const TextStyle(
      decoration: TextDecoration.none,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    ),
  });
}

class TenorTabBar extends StatefulWidget {
  final TabController tabController;
  final TenorTabBarStyle style;

  const TenorTabBar({
    Key? key,
    required this.tabController,
    required this.tabs,
    this.style = const TenorTabBarStyle(),
  }) : super(key: key);

  final List<String> tabs;

  @override
  _TenorTabBarState createState() => _TenorTabBarState();
}

class _TenorTabBarState extends State<TenorTabBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.length == 1) return const SizedBox();

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
            controller: widget.tabController,
            dividerHeight: 0,
            indicator: widget.style.indicator,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: widget.style.indicatorSize,
            indicatorWeight: 0,
            labelColor: widget.style.labelColor,
            labelPadding: const EdgeInsets.all(0),
            labelStyle: widget.style.labelStyle,
            tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
            unselectedLabelColor: widget.style.unselectedLabelColor,
            unselectedLabelStyle: widget.style.unselectedLabelStyle,
          ),
        ),
      ),
    );
  }
}
