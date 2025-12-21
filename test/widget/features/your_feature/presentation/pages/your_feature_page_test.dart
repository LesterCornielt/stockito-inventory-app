import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/your_feature/presentation/pages/your_feature_page.dart';
import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  group('YourFeaturePage Widget Tests', () {
    Widget createWidgetUnderTest() {
      return WidgetTestHelpers.createTestApp(
        child: const YourFeaturePage(),
      );
    }

    testWidgets('should display page title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Your Feature'), findsOneWidget);
    });

    testWidgets('should display placeholder icon', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.list_alt), findsOneWidget);
    });

    testWidgets('should display placeholder text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(
        find.text(
          'This is a placeholder for your new feature. Start building something amazing!',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have proper layout structure',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}

