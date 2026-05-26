import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/album_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumSearchProvider("eminem"));

    return Scaffold(
      appBar: AppBar(title: const Text("Search Albums")),
      body: albums.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final album = data[index];
            return ListTile(
              title: Text(album['title']),
              subtitle: Text(album['artist']['name']),
              leading: Image.network(album['album']['cover_small']),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}