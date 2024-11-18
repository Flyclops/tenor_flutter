import 'package:flutter/material.dart';

class TenorSheetProvider extends ChangeNotifier {
  final double minExtent;
  final double maxExtent;
  final double initialExtent;

  TenorSheetProvider({
    required DraggableScrollableController scrollController,
    required this.minExtent,
    required this.maxExtent,
    double? initialExtent,
  })  : initialExtent = initialExtent ?? maxExtent,
        _scrollController = scrollController;

  DraggableScrollableController _scrollController;

  DraggableScrollableController get scrollController => _scrollController;
  set scrollController(DraggableScrollableController controller) {
    _scrollController = controller;
    notifyListeners();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
