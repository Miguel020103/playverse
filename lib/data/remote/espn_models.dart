/// Modelos ligeros para parsear respuestas de ESPN.

class EspnScoreboard {
  final List<EspnEvent> events;
  EspnScoreboard({required this.events});

  factory EspnScoreboard.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'] as List<dynamic>? ?? [];
    return EspnScoreboard(
      events: eventsJson
          .map((e) => EspnEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EspnEvent {
  final String id;
  final String name;
  final String shortName;
  final DateTime date;
  final EspnStatus status;
  final EspnCompetitor home;
  final EspnCompetitor away;

  EspnEvent({
    required this.id,
    required this.name,
    required this.shortName,
    required this.date,
    required this.status,
    required this.home,
    required this.away,
  });

  factory EspnEvent.fromJson(Map<String, dynamic> json) {
    final competitions = json['competitions'] as List<dynamic>? ?? [];
    final competition = competitions.isNotEmpty
        ? competitions.first as Map<String, dynamic>
        : <String, dynamic>{};
    final competitors = competition['competitors'] as List<dynamic>? ?? [];

    EspnCompetitor? home;
    EspnCompetitor? away;
    for (final c in competitors) {
      final map = c as Map<String, dynamic>;
      final competitor = EspnCompetitor.fromJson(map);
      if (competitor.homeAway == 'home') {
        home = competitor;
      } else {
        away = competitor;
      }
    }

    return EspnEvent(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      shortName: json['shortName']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: EspnStatus.fromJson(json['status'] as Map<String, dynamic>? ?? {}),
      home: home ?? EspnCompetitor.empty(),
      away: away ?? EspnCompetitor.empty(),
    );
  }

  bool get isCompleted => status.type == 'STATUS_FINAL';
  bool get isInProgress => status.type == 'STATUS_IN_PROGRESS';
  bool get isScheduled => status.type == 'STATUS_SCHEDULED';
}

class EspnStatus {
  final String type;
  final String description;
  final String detail;
  final String shortDetail;

  EspnStatus({
    required this.type,
    required this.description,
    required this.detail,
    required this.shortDetail,
  });

  factory EspnStatus.fromJson(Map<String, dynamic> json) {
    final typeMap = json['type'] as Map<String, dynamic>? ?? {};
    return EspnStatus(
      type: typeMap['name']?.toString() ?? '',
      description: typeMap['description']?.toString() ?? '',
      detail: typeMap['detail']?.toString() ?? '',
      shortDetail: typeMap['shortDetail']?.toString() ?? '',
    );
  }
}

class EspnCompetitor {
  final String id;
  final String abbreviation;
  final String displayName;
  final String homeAway;
  final int score;
  final bool winner;

  EspnCompetitor({
    required this.id,
    required this.abbreviation,
    required this.displayName,
    required this.homeAway,
    required this.score,
    required this.winner,
  });

  factory EspnCompetitor.fromJson(Map<String, dynamic> json) {
    final team = json['team'] as Map<String, dynamic>? ?? {};
    return EspnCompetitor(
      id: team['id']?.toString() ?? '',
      abbreviation: team['abbreviation']?.toString() ?? '',
      displayName: team['displayName']?.toString() ?? '',
      homeAway: json['homeAway']?.toString() ?? '',
      score: int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      winner: json['winner'] == true,
    );
  }

  factory EspnCompetitor.empty() => EspnCompetitor(
        id: '',
        abbreviation: '',
        displayName: '',
        homeAway: '',
        score: 0,
        winner: false,
      );
}

/// Standing simplificado de un equipo.
class EspnStandingEntry {
  final String abbreviation;
  final String displayName;
  final int wins;
  final int losses;
  final int ties;
  final double winPercent;
  final String conference;
  final String? division;

  EspnStandingEntry({
    required this.abbreviation,
    required this.displayName,
    required this.wins,
    required this.losses,
    required this.ties,
    required this.winPercent,
    required this.conference,
    this.division,
  });
}