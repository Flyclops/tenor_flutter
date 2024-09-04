import 'package:flutter/material.dart';

class TenorSheetProvider extends ChangeNotifier {
  bool isExpanded = false;
  static const double minExtent = 0.7;
  static const double maxExtent = 0.9;
  double _initialExtent = minExtent;

  double get initialExtent => _initialExtent;
  set initialExtent(double iExtent) {
    _initialExtent = iExtent;
    notifyListeners();
  }
}
