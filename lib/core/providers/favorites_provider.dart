import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_provider.dart';

final favoritesProvider =
StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>(
      (ref) => FavoritesNotifier(ref),
);

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  FavoritesNotifier(this.ref) : super([]) {
    ref.listen(authStateProvider, (prev, next) {
      final uid = next.value?.uid;
      _load(uid);
    });

    final uid = ref.read(authStateProvider).value?.uid;
    _load(uid);
  }

  String _key(String uid) => "favorites_$uid";

  Future<void> _load(String? uid) async {
    if (uid == null) {
      state = [];
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key(uid));

    if (data != null) {
      state = List<Map<String, dynamic>>.from(jsonDecode(data));
    } else {
      state = [];
    }
  }

  Future<void> toggle(Map<String, dynamic> album) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;

    final exists = state.any((a) => a['id'] == album['id']);

    state = exists
        ? state.where((a) => a['id'] != album['id']).toList()
        : [...state, album];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(uid), jsonEncode(state));
  }

  Future<void> clear() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;

    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(uid));
  }

  bool isFavorite(int id) {
    return state.any((a) => a['id'] == id);
  }
}