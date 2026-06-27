import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final box = GetStorage();
  final key = 'favorites';

  FavoritesNotifier() : super([]) {
    load();
  }

  void load() {
    final data = box.read(key);
    if (data != null) {
      state = List<Map<String, dynamic>>.from(data);
    }
  }

  void toggle(Map<String, dynamic> album) {
    final exists = state.any((a) => a['id'] == album['id']);

    if (exists) {
      state = state.where((a) => a['id'] != album['id']).toList();
    } else {
      state = [...state, album];
    }

    box.write(key, state);
  }

  bool isFavorite(int id) {
    return state.any((a) => a['id'] == id);
  }
}