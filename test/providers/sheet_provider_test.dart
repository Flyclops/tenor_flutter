import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenor_flutter/src/providers/providers.dart';

void main() {
  const testMinExtent = 0.7;
  const tesInitialExtent = 0.8;
  const testMaxExtent = 0.9;
  final testScrollController = DraggableScrollableController();

  group('TenorSheetProvider >', () {
    test('Initializes as expected', () async {
      final provider = TenorSheetProvider(
        maxExtent: testMaxExtent,
        minExtent: testMinExtent,
        initialExtent: tesInitialExtent,
        scrollController: testScrollController,
      );

      expect(provider.initialExtent, tesInitialExtent);
      expect(provider.maxExtent, testMaxExtent);
      expect(provider.minExtent, testMinExtent);
      expect(provider.scrollController, testScrollController);
    });

    test('Can set scrollController', () async {
      final updatedScrollController = DraggableScrollableController();
      final provider = TenorSheetProvider(
        maxExtent: testMaxExtent,
        minExtent: testMinExtent,
        scrollController: testScrollController,
      );

      expect(provider.scrollController, testScrollController);

      provider.scrollController = updatedScrollController;

      expect(provider.scrollController, updatedScrollController);
    });
  });
}
