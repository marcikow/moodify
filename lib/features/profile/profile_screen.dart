import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/favorites_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 16),

            Text(
              user?.email ?? "No email",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 32),

            const Text(
              "Favorite Albums",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                child: Text("No favorite albums yet"),
              )
                  : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final album = favorites[index];

                  return Dismissible(
                    key: ValueKey(album['id']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(favoritesProvider.notifier).toggle(album);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () {
                          context.push('/album/${album['id']}');
                        },
                        leading: Image.network(
                          album['cover_medium'],
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(album['title']),
                        subtitle: Text(album['artist']['name']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}