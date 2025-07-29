import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/persistence_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<LocaleChanged>(_onLocaleChanged);
  }

  void _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    final themeMode = await PersistenceService.getThemeMode();
    final locale = await PersistenceService.getLocale();
    emit(
      state.copyWith(
        themeMode: themeMode,
        locale: locale,
        status: SettingsStatus.success,
      ),
    );
  }

  void _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await PersistenceService.saveThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onLocaleChanged(
    LocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await PersistenceService.saveLocale(event.newLocale);
    emit(state.copyWith(locale: event.newLocale));
  }
}
