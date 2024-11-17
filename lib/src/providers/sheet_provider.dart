import 'package:flutter/material.dart';

class TenorSheetProvider extends ChangeNotifier {
  final double minExtent = 0.7;
  final double maxExtent = 0.9;
  double _initialExtent;

  TenorSheetProvider({
    required DraggableScrollableController scrollController,
    required double minExtent,
    required double maxExtent,
  })  : _initialExtent = 0.4,
        _scrollController = scrollController;

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
