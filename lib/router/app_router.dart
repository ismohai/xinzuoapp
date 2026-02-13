import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xinzuo_app/screens/main_shell.dart';
import 'package:xinzuo_app/screens/home/home_screen.dart';
import 'package:xinzuo_app/screens/editor/editor_screen.dart';
import 'package:xinzuo_app/screens/setting/setting_screen.dart';
import 'package:xinzuo_app/screens/profile/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/editor/:bookId',
      name: 'editor',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final bookId = state.pathParameters['bookId'] ?? '';
        return EditorScreen(bookId: bookId);
      },
    ),
  ],
);
