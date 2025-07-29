import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _lastSearchQueryKey = 'last_search_query';
  static const String _navigationIndexKey = 'navigation_index';
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveLastSearchQuery(String query) async {
    await _prefs?.setString(_lastSearchQueryKey, query);
  }

  static Future<String?> getLastSearchQuery() async {
    return _prefs?.getString(_lastSearchQueryKey);
  }

  static Future<void> saveNavigationIndex(int index) async {
    await _prefs?.setInt(_navigationIndexKey, index);
  }

  static Future<int> getNavigationIndex() async {
    return _prefs?.getInt(_navigationIndexKey) ?? 0;
  }

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs?.setString(_themeModeKey, themeMode.name);
  }

  static Future<ThemeMode> getThemeMode() async {
    final themeModeName = _prefs?.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeModeName,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<void> saveLocale(Locale locale) async {
    await _prefs?.setString(_localeKey, locale.languageCode);
  }

  static Future<Locale> getLocale() async {
    final languageCode = _prefs?.getString(_localeKey);
    return Locale(languageCode ?? 'en');
  }
}
