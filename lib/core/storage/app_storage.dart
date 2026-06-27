import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static const _lastSearchKey = "last_search";

  static Future<void> saveLastSearch(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSearchKey, value);
  }

  static Future<String?> getLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSearchKey);
  }
}