import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/album_provider.dart';
import '../../core/providers/favorites_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../album/widgets/album_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.trim().isNotEmpty;

    final albums = hasQuery
        ? ref.watch(albumSearchProvider(query))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Albums"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },

              textInputAction: TextInputAction.search,

              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },

              decoration: InputDecoration(
                hintText: "Search albums...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: !hasQuery
                ? const Center(
              child: Text(
                "Start typing to search albums 🎧",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : albums!.when(
              data: (data) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final album = data[index];

                    return AlbumCard(album: album);
                  },
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}
