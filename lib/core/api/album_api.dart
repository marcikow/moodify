import 'dio_client.dart';

class AlbumApi {
  Future<List<dynamic>> searchAlbums(String query) async {
    final response = await dio.get('search', queryParameters: {
      'q': query,
    });

    return response.data['data'];
  }
}