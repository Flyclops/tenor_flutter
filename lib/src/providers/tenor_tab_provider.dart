import 'package:flutter/widgets.dart';

class TenorTabProvider with ChangeNotifier {
  String apiKey;
  Color? tabColor;
  Color? textSelectedColor;
  Color? textUnselectedColor;
  String? searchText;
  String rating = 'g';
  String lang = 'en_US';
  String randomID = '';

  String? _tabType;
  String get tabType => _tabType ?? '';
  set tabType(String tabType) {
    _tabType = tabType;
    notifyListeners();
  }

  TenorTabProvider({
    required this.apiKey,
    this.tabColor,
    this.textSelectedColor,
    this.textUnselectedColor,
    this.searchText,
    required this.rating,
    required this.randomID,
    required this.lang,
  });

  void setTabColor(Color tabColor) {
    tabColor = tabColor;
    notifyListeners();
  }
}
