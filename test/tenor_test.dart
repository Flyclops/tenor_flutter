import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:tenor_flutter/tenor_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tenor >', () {
    const tenorClient = Tenor(apiKey: '12345');

    test('Make sure it is the right type', () {
      expect(tenorClient, isA<Tenor>());
    });
  });

  testWidgets('Make sure bottom sheet opens and closes', (tester) async {
    final tenorClient = Tenor(
      apiKey: '12345',
      client: MockTenorHttpClient(),
    );
    late BuildContext savedContext;

    // create an app that we can show bottom sheet in
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            savedContext = context;
            return Container();
          },
        ),
      ),
    );

    // show bottom sheet
    tenorClient.showAsBottomSheet(context: savedContext);
    await tester.pump();

    // make sure it opens by finding a widget
    expect(find.byType(TenorSheet), findsOneWidget);

    // close bottom sheet
    await tester.tapAt(const Offset(20.0, 20.0));
    await tester.pumpAndSettle();

    // make sure it closes by finding no widgets
    expect(find.byType(TenorSheet), findsNothing);
  });
}
