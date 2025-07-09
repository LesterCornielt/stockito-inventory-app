import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(currentIndex: 0)) {
    on<NavigationChanged>(_onNavigationChanged);
  }

  void _onNavigationChanged(
    NavigationChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationState(currentIndex: event.index));
  }
}
