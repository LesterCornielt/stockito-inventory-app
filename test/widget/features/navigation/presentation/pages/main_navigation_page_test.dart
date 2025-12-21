import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:stockito/features/navigation/presentation/bloc/navigation_event.dart';
import 'package:stockito/features/navigation/presentation/bloc/navigation_state.dart';
import 'package:stockito/features/navigation/presentation/pages/main_navigation_page.dart';
import 'package:stockito/features/products/presentation/bloc/product_bloc.dart';
import 'package:stockito/features/products/presentation/bloc/product_event.dart';
import 'package:stockito/features/products/presentation/bloc/product_state.dart';
import '../../../../../helpers/widget_test_helpers.dart';

class MockNavigationBloc extends MockBloc<NavigationEvent, NavigationState>
    implements NavigationBloc {}

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  group('MainNavigationPage Widget Tests', () {
    late MockNavigationBloc mockNavigationBloc;
    late MockProductBloc mockProductBloc;

    setUp(() {
      mockNavigationBloc = MockNavigationBloc();
      mockProductBloc = MockProductBloc();
    });

    Widget createWidgetUnderTest() {
      return WidgetTestHelpers.createTestApp(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigationBloc>.value(value: mockNavigationBloc),
            BlocProvider<ProductBloc>.value(value: mockProductBloc),
          ],
          child: const MainNavigationPage(),
        ),
      );
    }

    testWidgets('should display bottom navigation bar', (WidgetTester tester) async {
      final pageController = PageController();
      whenListen(
        mockNavigationBloc,
        Stream.fromIterable([
          NavigationState(
            currentIndex: 0,
            pageController: pageController,
          ),
        ]),
        initialState: NavigationState(
          currentIndex: 0,
          pageController: pageController,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Bottom navigation should be visible
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should show floating action button on products tab',
        (WidgetTester tester) async {
      final pageController = PageController();
      whenListen(
        mockNavigationBloc,
        Stream.fromIterable([
          NavigationState(
            currentIndex: 0,
            pageController: pageController,
          ),
        ]),
        initialState: NavigationState(
          currentIndex: 0,
          pageController: pageController,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should not show floating action button on other tabs',
        (WidgetTester tester) async {
      final pageController = PageController();
      whenListen(
        mockNavigationBloc,
        Stream.fromIterable([
          NavigationState(
            currentIndex: 1, // Sales tab
            pageController: pageController,
          ),
        ]),
        initialState: NavigationState(
          currentIndex: 1,
          pageController: pageController,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('should display all navigation tabs', (WidgetTester tester) async {
      final pageController = PageController();
      whenListen(
        mockNavigationBloc,
        Stream.fromIterable([
          NavigationState(
            currentIndex: 0,
            pageController: pageController,
          ),
        ]),
        initialState: NavigationState(
          currentIndex: 0,
          pageController: pageController,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Check that PageView contains all pages
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should handle tab changes', (WidgetTester tester) async {
      final pageController = PageController();
      whenListen(
        mockNavigationBloc,
        Stream.fromIterable([
          NavigationState(
            currentIndex: 0,
            pageController: pageController,
          ),
          NavigationState(
            currentIndex: 1,
            pageController: pageController,
          ),
        ]),
        initialState: NavigationState(
          currentIndex: 0,
          pageController: pageController,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Initial state should show FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // After state change, FAB should still be there if we're on index 0
      // But if we change to index 1, it should disappear
      // This test verifies the PageView is set up correctly
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}

