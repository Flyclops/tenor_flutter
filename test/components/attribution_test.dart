import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Attribution Widget >', () {
    testWidgets('Make sure safe area overwrites any previous padding',
        (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            padding: EdgeInsets.only(bottom: 10),
          ),
          child: TenorAttribution(
            style: TenorAttributionStyle(padding: EdgeInsets.all(8)),
          ),
        ),
      );

      expect(
        (find.byType(Padding).first.evaluate().single.widget as Padding)
            .padding,
        const EdgeInsets.fromLTRB(8, 8, 8, 10),
      );
    });
  });
}
