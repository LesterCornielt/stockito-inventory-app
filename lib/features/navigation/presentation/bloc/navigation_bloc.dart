import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/persistence_service.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(currentIndex: 0)) {
    on<NavigationChanged>(_onNavigationChanged);
    on<LoadSavedNavigation>(_onLoadSavedNavigation);
  }

  void _onNavigationChanged(
    NavigationChanged event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationState(currentIndex: event.index));
    // Guardar el índice de navegación
    PersistenceService.saveNavigationIndex(event.index);
  }

  Future<void> _onLoadSavedNavigation(
    LoadSavedNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    final savedIndex = await PersistenceService.getNavigationIndex();
    emit(NavigationState(currentIndex: savedIndex));
  }
}
