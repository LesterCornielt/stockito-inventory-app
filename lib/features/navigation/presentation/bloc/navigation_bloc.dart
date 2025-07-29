import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/persistence_service.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc()
    : super(
        NavigationState(currentIndex: 0, pageController: PageController()),
      ) {
    on<TabChanged>(_onTabChanged);
    on<PageChanged>(_onPageChanged);
    on<LoadSavedNavigation>(_onLoadSavedNavigation);
  }

  void _onTabChanged(TabChanged event, Emitter<NavigationState> emit) {
    emit(
      NavigationState(
        currentIndex: event.index,
        pageController: state.pageController,
      ),
    );
    state.pageController.jumpToPage(event.index);
    PersistenceService.saveNavigationIndex(event.index);
  }

  void _onPageChanged(PageChanged event, Emitter<NavigationState> emit) {
    emit(
      NavigationState(
        currentIndex: event.index,
        pageController: state.pageController,
      ),
    );
    PersistenceService.saveNavigationIndex(event.index);
  }

  Future<void> _onLoadSavedNavigation(
    LoadSavedNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    final savedIndex = await PersistenceService.getNavigationIndex();
    emit(
      NavigationState(
        currentIndex: savedIndex,
        pageController: state.pageController,
      ),
    );
    state.pageController.jumpToPage(savedIndex);
  }

  @override
  Future<void> close() {
    state.pageController.dispose();
    return super.close();
  }
}
