import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  static const String _favKey = "favorites";

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_favKey);

    if (data == null) return;

    try {
      final decoded = jsonDecode(data);
      state = List<Map<String, dynamic>>.from(decoded);
    } catch (_) {
      state = [];
    }
  }

  Future<void> toggle(Map<String, dynamic> album) async {
    final exists = state.any((a) => a['id'] == album['id']);

    if (exists) {
      state = state.where((a) => a['id'] != album['id']).toList();
    } else {
      state = [...state, album];
    }

    await _save(state);
  }

  bool isFavorite(int id) {
    return state.any((a) => a['id'] == id);
  }

  Future<void> _save(List<Map<String, dynamic>> favs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favKey, jsonEncode(favs));
  }
}