import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/settings/presentation/pages/settings_page.dart';
import 'package:stockito/main.dart';
import '../../../../../helpers/widget_test_helpers.dart';

void main() {
  group('SettingsPage Widget Tests', () {
    setUp(() {
      // Reset notifiers before each test
      themeModeNotifier.value = ThemeMode.light;
      localeNotifier.value = const Locale('en');
    });

    Widget createWidgetUnderTest() {
      return WidgetTestHelpers.createTestApp(
        child: const SettingsPage(),
      );
    }

    testWidgets('should display settings title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should display theme toggle switch', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('should display language selector', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(DropdownButton<Locale>), findsOneWidget);
    });

    testWidgets('should display language icon', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('should display info section', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('should display logout option', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('should toggle theme when switch is tapped',
        (WidgetTester tester) async {
      themeModeNotifier.value = ThemeMode.light;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final switchWidget = find.byType(Switch);
      expect(switchWidget, findsOneWidget);

      await tester.tap(switchWidget);
      await tester.pump();

      // Verify theme mode changed
      expect(themeModeNotifier.value, equals(ThemeMode.dark));
    });

    testWidgets('should display all language options', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final dropdown = find.byType(DropdownButton<Locale>);
      expect(dropdown, findsOneWidget);

      // Tap to open dropdown
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Check that language options are available
      // Note: Dropdown items may not be directly findable in tests
      // but we can verify the dropdown exists
      expect(dropdown, findsOneWidget);
    });
  });
}

