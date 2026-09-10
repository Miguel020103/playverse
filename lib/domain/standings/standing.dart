class Standing {
  final String teamId;
  final String seasonId;
  final int wins;
  final int losses;
  final int ties;
  final int pointsFor;
  final int pointsAgainst;
  final int rank;
  final String context; // 'division' | 'conference' | 'league' | 'wildcard'

  // Advanced stats
  final int homeWins;
  final int homeLosses;
  final int homeTies;
  final int awayWins;
  final int awayLosses;
  final int awayTies;
  final int divisionWins;
  final int divisionLosses;
  final int divisionTies;
  final int conferenceWins;
  final int conferenceLosses;
  final int conferenceTies;
  final int currentStreak; // positive = wins, negative = losses
  final String streakType; // 'W' | 'L' | ''
  final int last5Wins;
  final int last5Losses;
  final int last5Ties;

  const Standing({
    required this.teamId,
    required this.seasonId,
    this.wins = 0,
    this.losses = 0,
    this.ties = 0,
    this.pointsFor = 0,
    this.pointsAgainst = 0,
    this.rank = 0,
    this.context = 'division',
    this.homeWins = 0,
    this.homeLosses = 0,
    this.homeTies = 0,
    this.awayWins = 0,
    this.awayLosses = 0,
    this.awayTies = 0,
    this.divisionWins = 0,
    this.divisionLosses = 0,
    this.divisionTies = 0,
    this.conferenceWins = 0,
    this.conferenceLosses = 0,
    this.conferenceTies = 0,
    this.currentStreak = 0,
    this.streakType = '',
    this.last5Wins = 0,
    this.last5Losses = 0,
    this.last5Ties = 0,
  });

  int get pointDifferential => pointsFor - pointsAgainst;

  int get gamesPlayed => wins + losses + ties;

  double get winPercentage {
    final total = wins + losses + ties;
    if (total == 0) return 0.0;
    return (wins + ties * 0.5) / total;
  }

  String get record => ties > 0 ? '$wins-$losses-$ties' : '$wins-$losses';

  String get homeRecord {
    final t = homeTies > 0 ? '-$homeTies' : '';
    return '$homeWins-$homeLosses$t';
  }

  String get awayRecord {
    final t = awayTies > 0 ? '-$awayTies' : '';
    return '$awayWins-$awayLosses$t';
  }

  String get divisionRecord {
    final t = divisionTies > 0 ? '-$divisionTies' : '';
    return '$divisionWins-$divisionLosses$t';
  }

  String get conferenceRecord {
    final t = conferenceTies > 0 ? '-$conferenceTies' : '';
    return '$conferenceWins-$conferenceLosses$t';
  }

  String get streakDisplay {
    if (currentStreak == 0) return '—';
    return '$streakType$currentStreak';
  }

  String get last5Display {
    final t = last5Ties > 0 ? '-$last5Ties' : '';
    return '$last5Wins-$last5Losses$t';
  }

  Standing copyWith({
    String? teamId,
    String? seasonId,
    int? wins,
    int? losses,
    int? ties,
    int? pointsFor,
    int? pointsAgainst,
    int? rank,
    String? context,
    int? homeWins,
    int? homeLosses,
    int? homeTies,
    int? awayWins,
    int? awayLosses,
    int? awayTies,
    int? divisionWins,
    int? divisionLosses,
    int? divisionTies,
    int? conferenceWins,
    int? conferenceLosses,
    int? conferenceTies,
    int? currentStreak,
    String? streakType,
    int? last5Wins,
    int? last5Losses,
    int? last5Ties,
  }) {
    return Standing(
      teamId: teamId ?? this.teamId,
      seasonId: seasonId ?? this.seasonId,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      ties: ties ?? this.ties,
      pointsFor: pointsFor ?? this.pointsFor,
      pointsAgainst: pointsAgainst ?? this.pointsAgainst,
      rank: rank ?? this.rank,
      context: context ?? this.context,
      homeWins: homeWins ?? this.homeWins,
      homeLosses: homeLosses ?? this.homeLosses,
      homeTies: homeTies ?? this.homeTies,
      awayWins: awayWins ?? this.awayWins,
      awayLosses: awayLosses ?? this.awayLosses,
      awayTies: awayTies ?? this.awayTies,
      divisionWins: divisionWins ?? this.divisionWins,
      divisionLosses: divisionLosses ?? this.divisionLosses,
      divisionTies: divisionTies ?? this.divisionTies,
      conferenceWins: conferenceWins ?? this.conferenceWins,
      conferenceLosses: conferenceLosses ?? this.conferenceLosses,
      conferenceTies: conferenceTies ?? this.conferenceTies,
      currentStreak: currentStreak ?? this.currentStreak,
      streakType: streakType ?? this.streakType,
      last5Wins: last5Wins ?? this.last5Wins,
      last5Losses: last5Losses ?? this.last5Losses,
      last5Ties: last5Ties ?? this.last5Ties,
    );
  }
}
