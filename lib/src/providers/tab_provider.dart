import 'package:flutter/widgets.dart';
import 'package:tenor_flutter/src/models/attribution.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

class TenorTabProvider with ChangeNotifier {
  Color? tabColor;
  Color? textSelectedColor;
  Color? textUnselectedColor;
  String? searchText;
  Tenor client;
  TenorAttributionType attributionType;

  // String? _tabType;
  // String get tabType => _tabType ?? '';
  // set tabType(String tabType) {
  //   _tabType = tabType;
  //   notifyListeners();
  // }

  TenorTabProvider({
    this.tabColor,
    this.textSelectedColor,
    this.textUnselectedColor,
    this.searchText,
    required this.client,
    required this.attributionType,
  });

  void setTabColor(Color tabColor) {
    tabColor = tabColor;
    notifyListeners();
  }
}
