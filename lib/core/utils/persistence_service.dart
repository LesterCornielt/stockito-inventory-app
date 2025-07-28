import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _lastSearchQueryKey = 'last_search_query';
  static const String _navigationIndexKey = 'navigation_index';

  static Future<void> saveLastSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSearchQueryKey, query);
  }

  static Future<String?> getLastSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSearchQueryKey);
  }

  static Future<void> saveNavigationIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navigationIndexKey, index);
  }

  static Future<int> getNavigationIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_navigationIndexKey) ?? 0;
  }
}
