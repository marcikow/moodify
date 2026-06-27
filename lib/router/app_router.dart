import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/album/album_details_screen.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final isAuthRoute =
        state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

    if (user == null && !isAuthRoute) {
      return '/login';
    }

    if (user != null && isAuthRoute) {
      return '/';
    }

    return null;
  },

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _getIndex(state.uri.toString()),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/search');
                  break;
                case 2:
                  context.go('/profile');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/album',
          builder: (context, state) => const AlbumScreen(),
        ),
        GoRoute(
          path: '/album/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AlbumDetailsScreen(albumId: int.parse(id));
          },
        ),
      ],
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

int _getIndex(String location) {
  if (location.startsWith('/search')) return 1;
  if (location.startsWith('/profile')) return 2;
  return 0;
}