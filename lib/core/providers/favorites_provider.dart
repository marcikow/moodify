import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoritesNotifier() : super([]) {
    load();
  }

  String _key() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    return "favorites_$uid";
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key());

    if (data != null) {
      state = List<Map<String, dynamic>>.from(jsonDecode(data));
    } else {
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

    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(), jsonEncode(state));
  }

  bool isFavorite(int id) {
    return state.any((a) => a['id'] == id);
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key());
  }
}