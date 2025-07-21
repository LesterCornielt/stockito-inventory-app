import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _navigationIndexKey = 'navigation_index';
  static const String _lastSearchQueryKey = 'last_search_query';
  static const String _lastReportDateKey = 'last_report_date';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _showSampleDialogKey = 'show_sample_dialog';

  static Future<void> saveNavigationIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navigationIndexKey, index);
  }

  static Future<int> getNavigationIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_navigationIndexKey) ?? 0;
  }

  static Future<void> saveLastSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSearchQueryKey, query);
  }

  static Future<String?> getLastSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSearchQueryKey);
  }

  static Future<void> saveLastReportDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastReportDateKey, date.toIso8601String());
  }

  static Future<DateTime?> getLastReportDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_lastReportDateKey);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_isFirstLaunchKey) ?? true;
    if (isFirst) {
      await prefs.setBool(_isFirstLaunchKey, false);
    }
    return isFirst;
  }

  static Future<void> setShowSampleDialog(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showSampleDialogKey, value);
  }

  static Future<bool> getShowSampleDialog() async {
    final prefs = await SharedPreferences.getInstance();
    // Por defecto, mostrar el cuadro (true)
    return prefs.getBool(_showSampleDialogKey) ?? true;
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
