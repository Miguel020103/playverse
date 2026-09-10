import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/game_repository.dart';
import '../../domain/game/game.dart';
import '../teams/teams_provider.dart';
import '../user/user_provider.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

final gameResultsVersionProvider = StateProvider<int>((ref) => 0);

final gamesLiveProvider = Provider<List<Game>>((ref) {
  ref.watch(gameResultsVersionProvider);
  ref.watch(userPreferencesProvider);
  return ref.watch(gameRepositoryProvider).getAllGames();
});

final upcomingGamesProvider = Provider<List<Game>>((ref) {
  final games = ref.watch(gamesLiveProvider);
  return games.where((g) => g.status == GameStatus.scheduled).toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});

final followedUpcomingGamesProvider = Provider<List<Game>>((ref) {
  final followed = ref.watch(followedTeamsProvider);
  final ids = followed.map((t) => t.id).toSet();
  if (ids.isEmpty) return [];

  return ref
      .watch(gamesLiveProvider)
      .where((g) =>
          g.status == GameStatus.scheduled &&
          (ids.contains(g.homeTeamId) || ids.contains(g.awayTeamId)))
      .toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});

final completedGamesProvider = Provider<List<Game>>((ref) {
  return ref
      .watch(gamesLiveProvider)
      .where((g) => g.isCompleted)
      .toList()
    ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
});

final saveGameResultProvider = Provider((ref) {
  return ({
    required String gameId,
    required int homeScore,
    required int awayScore,
  }) async {
    await ref.read(gameRepositoryProvider).saveResult(
          gameId: gameId,
          homeScore: homeScore,
          awayScore: awayScore,
        );
    ref.read(gameResultsVersionProvider.notifier).state++;
  };
});

final clearGameResultProvider = Provider((ref) {
  return ({required String gameId}) async {
    await ref.read(gameRepositoryProvider).clearResult(gameId);
    ref.read(gameResultsVersionProvider.notifier).state++;
  };
});
