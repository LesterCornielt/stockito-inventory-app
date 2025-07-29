part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final SettingsStatus status;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.status = SettingsStatus.initial,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    SettingsStatus? status,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [themeMode, locale, status];
}
