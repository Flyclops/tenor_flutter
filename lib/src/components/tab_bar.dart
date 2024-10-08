import 'package:flutter/material.dart';

class TenorTabBarStyle {
  final Decoration decoration;
  final Decoration indicator;
  final Color labelColor;
  final EdgeInsets indicatorPadding;
  final TabBarIndicatorSize indicatorSize;
  final TextStyle labelStyle;
  final double height;

  /// Space between the tab bar and surrounding content.
  final EdgeInsets margin;
  final Color unselectedLabelColor;
  final TextStyle unselectedLabelStyle;

  const TenorTabBarStyle({
    this.decoration = const BoxDecoration(
      color: Color(0xFFEDE7D7),
      border: Border.symmetric(
        horizontal: BorderSide(
          color: Color(0xFFEDE7D7),
          width: 2,
        ),
        vertical: BorderSide(
          color: Color(0xFFEDE7D7),
          width: 2,
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.indicator = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      gradient: LinearGradient(
        colors: [Color(0xFFFECD4E), Color(0xFFFEAD4E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      border: Border.symmetric(
        horizontal: BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
        vertical: BorderSide(
          color: Color.fromRGBO(255, 255, 255, 0.2),
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          blurRadius: 1,
          offset: Offset(0, 0),
        ),
      ],
    ),
    this.indicatorPadding = EdgeInsets.zero,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.labelColor = const Color(0xFF3B3B3B),
    this.labelStyle = const TextStyle(
      decoration: TextDecoration.none,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.height = 30,
    this.margin = const EdgeInsets.only(
      left: 8,
      right: 8,
    ),
    this.unselectedLabelColor = const Color(0xFF3B3B3B),
    this.unselectedLabelStyle = const TextStyle(
      decoration: TextDecoration.none,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  });
}

class TenorTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;
  final TenorTabBarStyle style;

  const TenorTabBar({
    required this.tabController,
    required this.tabs,
    this.style = const TenorTabBarStyle(),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (tabs.length == 1) return const SizedBox();

    return Padding(
      padding: style.margin,
      child: Container(
        decoration: style.decoration,
        child: SizedBox(
          height: style.height,
          child: TabBar(
            controller: tabController,
            dividerHeight: 0,
            indicator: style.indicator,
            indicatorPadding: style.indicatorPadding,
            indicatorSize: style.indicatorSize,
            indicatorWeight: 0,
            labelColor: style.labelColor,
            labelPadding: const EdgeInsets.all(0),
            labelStyle: style.labelStyle,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            unselectedLabelColor: style.unselectedLabelColor,
            unselectedLabelStyle: style.unselectedLabelStyle,
          ),
        ),
      ),
    );
  }
}
