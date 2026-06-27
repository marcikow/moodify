import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'widgets/auth_field.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/l10n/app_strings.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              final current = ref.read(localeProvider);
              ref
                  .read(localeProvider.notifier)
                  .setLocale(current == "en" ? "pl" : "en");
            },
            child: Text(lang.toUpperCase()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.get("register", lang),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppStrings.get("create_account", lang),
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            AuthField(
              controller: email,
              label: AppStrings.get("email", lang),
            ),

            const SizedBox(height: 12),

            AuthField(
              controller: password,
              label: AppStrings.get("password", lang),
              obscure: true,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(AppStrings.get("create_account", lang)),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppStrings.get("already_have_account", lang)),
            ),
          ],
        ),
      ),
    );
  }
}