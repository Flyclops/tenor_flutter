import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenor_flutter/src/utilities/is_tablet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isTablet >', () {
    testWidgets('true when iPad Pro (12.9-inch) (5th generation)',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(1192.0, 1558.0),
          ),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(isTablet(context), isTrue);

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
    testWidgets('false when iPhone 17 Pro', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(402.0, 874.0),
          ),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                expect(isTablet(context), isFalse);

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });
}
