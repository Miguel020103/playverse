import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/game.dart';
import '../user/user_provider.dart';
import 'games_provider.dart';

/// Filtro activo: todos los partidos o solo los de mis equipos.
enum GamesFilter { all, myTeams }

final gamesFilterProvider = StateProvider<GamesFilter>((ref) => GamesFilter.all);

/// Partidos filtrados según la preferencia del usuario.
final filteredGamesProvider = Provider.family<List<Game>, int>((ref, week) {
  final filter = ref.watch(gamesFilterProvider);
  final allGames = ref.watch(gamesLiveProvider);
  final userPrefs = ref.watch(userPreferencesProvider);

  var weekGames = allGames
      .where((g) => g.id.startsWith('w$week'))
      .toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  if (filter == GamesFilter.myTeams) {
    final favoriteIds = <String>{};
    if (userPrefs.mainTeamId != null) favoriteIds.add(userPrefs.mainTeamId!);
    if (userPrefs.secondTeamId != null) favoriteIds.add(userPrefs.secondTeamId!);
    favoriteIds.addAll(userPrefs.followedTeamIds);

    if (favoriteIds.isNotEmpty) {
      weekGames = weekGames
          .where((g) =>
              favoriteIds.contains(g.homeTeamId) ||
              favoriteIds.contains(g.awayTeamId))
          .toList();
    }
  }

  return weekGames;
});