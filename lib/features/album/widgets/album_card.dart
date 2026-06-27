import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/favorites_provider.dart';

class AlbumCard extends ConsumerWidget {
  final Map<String, dynamic> album;

  const AlbumCard({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
            (fav) => fav.any((a) => a['id'] == album['id']),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            context.push('/album/${album['id']}');
          },
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        album['cover_medium'],
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      right: 8,
                      top: 8,
                      child: IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .toggle(album);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      album['artist']['name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}