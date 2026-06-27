import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, String>(
      (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super("en") {
    _load();
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString("locale") ?? "en";
  }

  void setLocale(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", lang);
    state = lang;
  }
}