import 'package:flutter/material.dart';

class TenorSheetProvider extends ChangeNotifier {
  TenorSheetProvider({
    required scrollController,
  }) : _scrollController = scrollController;

  bool isExpanded = false;
  static const double minExtent = 0.7;
  static const double maxExtent = 0.9;
  double _initialExtent = minExtent;
  DraggableScrollableController _scrollController;

  DraggableScrollableController get scrollController => _scrollController;
  set scrollController(DraggableScrollableController controller) {
    _scrollController = controller;
    notifyListeners();
  }

  double get initialExtent => _initialExtent;
  set initialExtent(double iExtent) {
    _initialExtent = iExtent;
    notifyListeners();
  }
}
