import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/game.dart';
import '../games/games_provider.dart';
import '../user/user_provider.dart';

class WeeklySummary {
  final int week;
  final int totalGames;
  final int completedGames;
  final int wins;
  final int losses;
  final int ties;
  final List<Game> favoriteGames;

  const WeeklySummary({
    required this.week,
    required this.totalGames,
    required this.completedGames,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.favoriteGames,
  });

  double get winRate =>
      completedGames == 0 ? 0 : wins / completedGames;
}

/// Resumen de la semana para los equipos favoritos del usuario.
final weeklySummaryProvider = Provider.family<WeeklySummary, int>((ref, week) {
  final games = ref.watch(gamesLiveProvider);
  final prefs = ref.watch(userPreferencesProvider);

  final favoriteIds = <String>{};
  if (prefs.mainTeamId != null) favoriteIds.add(prefs.mainTeamId!);
  if (prefs.secondTeamId != null) favoriteIds.add(prefs.secondTeamId!);
  favoriteIds.addAll(prefs.followedTeamIds);

  final weekGames = games
      .where((g) => g.id.startsWith('w$week'))
      .where((g) =>
          favoriteIds.isEmpty ||
          favoriteIds.contains(g.homeTeamId) ||
          favoriteIds.contains(g.awayTeamId))
      .toList();

  int wins = 0, losses = 0, ties = 0;

  for (final g in weekGames) {
    if (!g.isCompleted || g.result == null) continue;

    final homeScore = g.result!.homeScore;
    final awayScore = g.result!.awayScore;

    // Contamos victoria si alguno de los favoritos ganó
    final homeIsFav = favoriteIds.contains(g.homeTeamId);
    final awayIsFav = favoriteIds.contains(g.awayTeamId);

    if (homeScore == awayScore) {
      ties++;
    } else if (homeScore > awayScore && homeIsFav) {
      wins++;
    } else if (awayScore > homeScore && awayIsFav) {
      wins++;
    } else if (homeIsFav || awayIsFav) {
      losses++;
    }
  }

  return WeeklySummary(
    week: week,
    totalGames: weekGames.length,
    completedGames: weekGames.where((g) => g.isCompleted).length,
    wins: wins,
    losses: losses,
    ties: ties,
    favoriteGames: weekGames,
  );
});