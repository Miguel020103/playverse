import '../../domain/game/game.dart';
import '../local/hive/hive_boxes.dart';
import '../nfl/nfl_schedule_seed.dart';

class GameRepository {
  static const _resultsKey = 'game_results';

  List<Game> getAllGames() {
    final seed = NflScheduleSeed.all();
    final results = _loadResults();

    return seed.map((g) {
      final r = results[g.id];
      if (r == null) return g;
      return g.copyWith(
        status: GameStatus.completed,
        result: GameResult(
          homeScore: r['home'] as int,
          awayScore: r['away'] as int,
        ),
        source: DataSourceType.manual,
      );
    }).toList();
  }

  List<Game> gamesForTeam(String teamId) {
    return getAllGames()
        .where((g) => g.homeTeamId == teamId || g.awayTeamId == teamId)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<Game> upcoming({int limit = 10}) {
    final list = getAllGames()
        .where((g) => g.status == GameStatus.scheduled)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return list.take(limit).toList();
  }

  Future<void> saveResult({
    required String gameId,
    required int homeScore,
    required int awayScore,
  }) async {
    final results = _loadResults();
    results[gameId] = {'home': homeScore, 'away': awayScore};
    await HiveBoxes.seasonBox.put(_resultsKey, results);
  }

  Future<void> clearResult(String gameId) async {
    final results = _loadResults();
    results.remove(gameId);
    await HiveBoxes.seasonBox.put(_resultsKey, results);
  }

  Map<String, Map> _loadResults() {
    final raw = HiveBoxes.seasonBox.get(_resultsKey);
    if (raw == null) return {};
    final map = Map<String, dynamic>.from(raw as Map);
    return map.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));
  }
}
