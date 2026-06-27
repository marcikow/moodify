import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/providers/theme_provider.dart';

import '../../core/l10n/app_strings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final theme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get("settings", lang)),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppStrings.get("language", lang)),
            subtitle: Text(lang == "en" ? "English" : "Polski"),
            onTap: () {
              final current = ref.read(localeProvider);

              final newLang = current == "en" ? "pl" : "en";

              ref.read(localeProvider.notifier).setLocale(newLang);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    newLang == "en" ? "English selected" : "Polski wybrany",
                  ),
                  duration: const Duration(milliseconds: 800),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(AppStrings.get("theme", lang)),
            subtitle: Text(
              switch (theme) {
                ThemeMode.light => "Light",
                ThemeMode.dark => "Dark",
                ThemeMode.system => "System",
              },
            ),
            onTap: () {
              final current = ref.read(themeProvider);

              ThemeMode newMode = switch (current) {
                ThemeMode.light => ThemeMode.dark,
                ThemeMode.dark => ThemeMode.system,
                ThemeMode.system => ThemeMode.light,
              };

              ref.read(themeProvider.notifier).setTheme(newMode);
            },
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text(AppStrings.get("delete_account", lang)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete account?"),
                  content: const Text(
                    "This action cannot be undone.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              try {
                await FirebaseAuth.instance.currentUser?.delete();
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Re-authentication required"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}