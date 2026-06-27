import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _load();
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("theme");

    state = switch (value) {
      "dark" => ThemeMode.dark,
      "system" => ThemeMode.system,
      _ => ThemeMode.light,
    };
  }

  void setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", mode.name);
    state = mode;
  }
}