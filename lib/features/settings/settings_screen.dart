import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("EN / PL"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text("Theme"),
            subtitle: const Text("Light / Dark / System"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text("Delete account"),
            onTap: () async {
              await FirebaseAuth.instance.currentUser?.delete();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }
}