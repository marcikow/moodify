import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../album/widgets/album_card.dart';
import '../../core/providers/album_provider.dart';
import '../../core/storage/app_storage.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/l10n/app_strings.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String query = "";
  String? lastSearch;

  @override
  void initState() {
    super.initState();
    loadLastSearch();
  }

  Future<void> loadLastSearch() async {
    final last = await AppStorage.getLastSearch();

    setState(() {
      lastSearch = last;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final hasQuery = query.trim().isNotEmpty;

    final albums = hasQuery ? ref.watch(albumSearchProvider(query)) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get("search", lang)),
      ),
      body: Column(
        children: [
          if (lastSearch != null && lastSearch!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Last search: $lastSearch",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (value) async {
                await AppStorage.saveLastSearch(value);
              },
              decoration: InputDecoration(
                hintText: AppStrings.get("search_hint", lang),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: !hasQuery
                ? Center(
              child: Text(
                AppStrings.get("start_typing", lang),
                style: const TextStyle(color: Colors.grey),
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