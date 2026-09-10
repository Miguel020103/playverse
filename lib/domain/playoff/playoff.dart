class Playoff {
  final String id;
  final String seasonId;
  final String format;
  final List<String> participantTeamIds;

  const Playoff({
    required this.id,
    required this.seasonId,
    required this.format,
    this.participantTeamIds = const [],
  });
}

class PlayoffRound {
  final String id;
  final String playoffId;
  final String name;
  final String nameEs;
  final int order;
  final List<String> gameIds;

  const PlayoffRound({
    required this.id,
    required this.playoffId,
    required this.name,
    required this.nameEs,
    required this.order,
    this.gameIds = const [],
  });
}
