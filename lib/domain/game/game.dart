enum GameStatus {
  scheduled,
  completed,
  cancelled,
  postponed,
}

enum DataSourceType {
  manual,
  remote,
}

class GameResult {
  final int homeScore;
  final int awayScore;

  const GameResult({
    required this.homeScore,
    required this.awayScore,
  });
}

class Game {
  final String id;
  final String seasonId;
  final String homeTeamId;
  final String awayTeamId;
  final DateTime scheduledAt;
  final GameStatus status;
  final GameResult? result;
  final DataSourceType source;

  const Game({
    required this.id,
    required this.seasonId,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.scheduledAt,
    required this.status,
    this.result,
    this.source = DataSourceType.manual,
  });

  bool get isCompleted => status == GameStatus.completed && result != null;

  Game copyWith({
    String? id,
    String? seasonId,
    String? homeTeamId,
    String? awayTeamId,
    DateTime? scheduledAt,
    GameStatus? status,
    GameResult? result,
    DataSourceType? source,
  }) {
    return Game(
      id: id ?? this.id,
      seasonId: seasonId ?? this.seasonId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      result: result ?? this.result,
      source: source ?? this.source,
    );
  }
}
