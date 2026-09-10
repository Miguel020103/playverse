import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/user/user_provider.dart';
import '../../domain/user/user.dart';
import '../screens/achievements/achievements_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/divisions/divisions_screen.dart';
import '../screens/games/game_detail_screen.dart';
import '../screens/games/games_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/more/more_screen.dart';
import '../screens/onboarding/team_selection_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/sports/sport_selection_screen.dart';
import '../screens/summary/weekly_summary_screen.dart'; // ← NUEVO
import '../screens/team/team_locker_screen.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    _ref.listen<UserPreferences>(userPreferencesProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref _ref;

  UserPreferences get prefs => _ref.read(userPreferencesProvider);
}

final routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  return RouterRefreshNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.read(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: refresh,
    redirect: (context, state) {
      final completed = refresh.prefs.onboardingCompleted;
      final loc = state.matchedLocation;

      const onboardingPaths = ['/welcome', '/sport', '/select-team'];
      final isOnboarding = onboardingPaths.any((p) => loc == p);

      if (completed && isOnboarding) return '/home';

      if (!completed &&
          (loc == '/home' ||
              loc.startsWith('/team') ||
              loc == '/divisions' ||
              loc == '/calendar' ||
              loc == '/games' ||
              loc.startsWith('/game/') ||
              loc == '/summary' ||
              loc == '/achievements' ||
              loc == '/more')) {
        return '/welcome';
      }

      return null;
    },
    routes: [
      // ---------- Onboarding ----------
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/sport',
        name: 'sport',
        builder: (context, state) => const SportSelectionScreen(),
      ),
      GoRoute(
        path: '/select-team',
        name: 'select-team',
        builder: (context, state) {
          final isSecond = state.uri.queryParameters['second'] == 'true';
          return TeamSelectionScreen(selectingSecondTeam: isSecond);
        },
      ),

      // ---------- Shell (tabs) ----------
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/divisions',
            name: 'divisions',
            builder: (context, state) => const DivisionsScreen(),
          ),
          GoRoute(
            path: '/games',
            name: 'games',
            builder: (context, state) => const GamesScreen(),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/more',
            name: 'more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),

      // ---------- Detalle de partido ----------
      GoRoute(
        path: '/game/:id',
        name: 'game-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GameDetailScreen(gameId: id);
        },
      ),

      // ---------- Resumen semanal ----------
      GoRoute(
        path: '/summary',
        name: 'weekly-summary',
        builder: (context, state) {
          final week =
              int.tryParse(state.uri.queryParameters['week'] ?? '1') ?? 1;
          return WeeklySummaryScreen(initialWeek: week);
        },
      ),

      // ---------- Otras ----------
      GoRoute(
        path: '/team/:id',
        name: 'team',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TeamLockerScreen(teamId: id);
        },
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: Center(
        child: Text(
          'Ruta no encontrada',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ),
    ),
  );
});