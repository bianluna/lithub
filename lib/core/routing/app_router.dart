import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:litapp/core/providers.dart';
import 'package:litapp/core/widgets/app_shell.dart';
import 'package:litapp/features/auth/login_screen.dart';
import 'package:litapp/features/books/book_detail_screen.dart';
import 'package:litapp/features/calendar/calendar_screen.dart';
import 'package:litapp/features/challenges/challenges_screen.dart';
import 'package:litapp/features/clubs/club_detail_screen.dart';
import 'package:litapp/features/clubs/clubs_screen.dart';
import 'package:litapp/features/home/home_screen.dart';
import 'package:litapp/features/notifications/notifications_screen.dart';
import 'package:litapp/features/profile/profile_screen.dart';
import 'package:litapp/features/rankings/ranking_screen.dart';
import 'package:litapp/features/reading/reading_screen.dart';
import 'package:litapp/features/rewards/rewards_screen.dart';
import 'package:litapp/features/settings/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final repo = ref.read(litRepositoryProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: repo,
    redirect: (context, state) {
      final location = state.uri.path;
      final loggedIn = repo.signedIn;
      final isLogin = location == '/login';
      if (!loggedIn && !isLogin) return '/login';
      if (loggedIn && isLogin) return '/home';
      if (location == '/') return loggedIn ? '/home' : '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child, location: state.uri.path),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/clubs', builder: (context, state) => const ClubsScreen()),
          GoRoute(
            path: '/clubs/:id',
            builder: (context, state) => ClubDetailScreen(clubId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/reading', builder: (context, state) => const ReadingScreen()),
          GoRoute(
            path: '/books/:id',
            builder: (context, state) => BookDetailScreen(bookId: state.pathParameters['id']!),
          ),
          GoRoute(path: '/ranking', builder: (context, state) => const RankingScreen()),
          GoRoute(path: '/challenges', builder: (context, state) => const ChallengesScreen()),
          GoRoute(path: '/rewards', builder: (context, state) => const RewardsScreen()),
          GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
          GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
