import 'package:flutter/material.dart';
import 'package:tenor_flutter/src/components/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenor_flutter/tenor_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Category Widget >', () {
    testWidgets('If category is null, find nothing', (tester) async {
      await tester.pumpWidget(
        const TenorCategoryWidget(),
      );

      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('Keep hashtag', (tester) async {
      final tenorCategoryTest = TenorCategory(
        name: '#test',
        searchTerm: 'test search term',
        path: 'path/to/category',
        image: 'https://flyclops.com/images/logo.png',
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TenorCategoryWidget(
            category: tenorCategoryTest,
            style: const TenorCategoryStyle(
              stripHashtag: false,
            ),
          ),
        ),
      );

      expect(find.text('test'), findsNothing);
      expect(find.text('#test'), findsOneWidget);
    });

    testWidgets('Strip hashtag', (tester) async {
      final tenorCategoryTest = TenorCategory(
        name: '#test',
        searchTerm: 'test search term',
        path: 'path/to/category',
        image: 'https://flyclops.com/images/logo.png',
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TenorCategoryWidget(
            category: tenorCategoryTest,
            style: const TenorCategoryStyle(
              stripHashtag: true,
            ),
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
      expect(find.text('#test'), findsNothing);
    });

    testWidgets('Make sure it renders and is tappable', (tester) async {
      // track if the tap was tapped
      bool hasTapped = false;

      // category to populate with
      final tenorCategoryTest = TenorCategory(
        name: 'test',
        searchTerm: 'test search term',
        path: 'path/to/category',
        image: 'https://flyclops.com/images/logo.png',
      );

      // display the category widget
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TenorCategoryWidget(
            category: tenorCategoryTest,
            onTap: (tenorCategory) {
              expect(tenorCategory, tenorCategoryTest);
              hasTapped = true;
            },
          ),
        ),
      );

      // it should not have been tapped at this point
      expect(hasTapped, false);

      // tap it
      await tester.tap(find.byType(GestureDetector));

      // make sure the tap went through
      expect(hasTapped, true);
    });
  });
}
