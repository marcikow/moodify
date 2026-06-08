import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "test@test.com",
      password: "123456",
    );

    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    setState(() {
      user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user == null ? "Not logged in" : "Logged in"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: logout,
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}