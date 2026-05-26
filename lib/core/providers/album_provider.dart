import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/album_api.dart';

final albumApiProvider = Provider((ref) => AlbumApi());

final albumSearchProvider = FutureProvider.family((ref, String query) async {
  final api = ref.read(albumApiProvider);
  return api.searchAlbums(query);
});