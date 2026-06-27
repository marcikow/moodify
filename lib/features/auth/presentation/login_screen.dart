import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/auth_field.dart';
import 'register_screen.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/l10n/app_strings.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'User not found';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'invalid-credential':
          message = 'Invalid credentials';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try later.';
          break;
        default:
          message = e.message ?? 'Login error';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
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
              AppStrings.get("login", lang),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              AppStrings.get("welcome_back", lang),
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
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(AppStrings.get("login", lang)),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: Text(AppStrings.get("register", lang)),
            ),
          ],
        ),
      ),
    );
  }
}