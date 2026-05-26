import 'dio_client.dart';

class AlbumApi {
  Future<List<dynamic>> searchAlbums(String query) async {
    final response = await dio.get(
      'search/album',
      queryParameters: {'q': query},
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>> getAlbum(int id) async {
    final res = await dio.get('album/$id');
    return res.data;
  }
}