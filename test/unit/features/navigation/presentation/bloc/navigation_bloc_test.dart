import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:stockito/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:stockito/features/navigation/presentation/bloc/navigation_state.dart';

void main() {
  group('NavigationBloc', () {
    test('initial state should have currentIndex 0', () {
      // Note: NavigationBloc uses PageController which requires a PageView
      // For unit tests, we verify the basic structure
      final bloc = NavigationBloc();
      expect(bloc.state.currentIndex, equals(0));
      expect(bloc.state.pageController, isA<PageController>());
      bloc.close();
    });

    // Note: Tests for TabChanged, PageChanged, and LoadSavedNavigation
    // are limited in unit tests because PageController.jumpToPage requires
    // a PageView to be attached. These are better tested in widget tests
    // where a real PageView can be provided.
    //
    // The NavigationBloc logic is simple enough that integration/widget tests
    // will provide better coverage of the actual behavior.
  });
}

