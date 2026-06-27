import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/album_provider.dart';
import '/core/utils/time_utils.dart';

class AlbumDetailsScreen extends ConsumerWidget {
  final int albumId;

  const AlbumDetailsScreen({
    super.key,
    required this.albumId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final album = ref.watch(albumDetailsProvider(albumId));

    return Scaffold(
      body: album.when(
        data: (data) {
          final tracks = data['tracks']['data'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    data['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        data['cover_big'],
                        fit: BoxFit.cover,
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black54,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Artist: ${data['artist']['name']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final track = tracks[index];

                    return ListTile(
                      leading: Text("${index + 1}"),
                      title: Text(track['title']),
                      trailing: Text(
                        formatDuration(track['duration']),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                  childCount: tracks.length,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}