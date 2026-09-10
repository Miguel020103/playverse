import '../../domain/game/game.dart';
import '../remote/espn_api_client.dart';
import '../remote/espn_models.dart';

/// Servicio de alto nivel: resultados, scoreboards y standings desde ESPN.
class EspnScoreService {
  EspnScoreService({EspnApiClient? client})
      : _client = client ?? EspnApiClient();

  final EspnApiClient _client;

  /// Mapeo abreviatura ESPN → ID interno PlayVerse
  static const Map<String, String> abbrToTeamId = {
    'BUF': 'buf_bills',
    'MIA': 'mia_dolphins',
    'NE': 'ne_patriots',
    'NYJ': 'ny_jets',
    'BAL': 'bal_ravens',
    'CIN': 'cin_bengals',
    'CLE': 'cle_browns',
    'PIT': 'pit_steelers',
    'HOU': 'hou_texans',
    'IND': 'ind_colts',
    'JAX': 'jax_jaguars',
    'TEN': 'ten_titans',
    'DEN': 'den_broncos',
    'KC': 'kc_chiefs',
    'LV': 'lv_raiders',
    'LAC': 'lac_chargers',
    'DAL': 'dal_cowboys',
    'NYG': 'ny_giants',
    'PHI': 'phi_eagles',
    'WSH': 'was_commanders',
    'WAS': 'was_commanders',
    'CHI': 'chi_bears',
    'DET': 'det_lions',
    'GB': 'gb_packers',
    'MIN': 'min_vikings',
    'ATL': 'atl_falcons',
    'CAR': 'car_panthers',
    'NO': 'no_saints',
    'TB': 'tb_buccaneers',
    'ARI': 'ari_cardinals',
    'LAR': 'lar_rams',
    'SF': 'sf_49ers',
    'SEA': 'sea_seahawks',
  };

  Future<List<EspnEvent>> fetchScoreboard({String? date}) async {
    final json = await _client.getScoreboard(date: date);
    return EspnScoreboard.fromJson(json).events;
  }

  Future<List<EspnEvent>> fetchScoreboardByWeek({
    required int year,
    required int week,
    int seasontype = 2,
  }) async {
    final json = await _client.getScoreboardByWeek(
      year: year,
      week: week,
      seasontype: seasontype,
    );
    return EspnScoreboard.fromJson(json).events;
  }

  Future<EspnEvent?> findMatchingEvent(Game localGame) async {
    final dateStr = _formatDate(localGame.scheduledAt);
    final events = await fetchScoreboard(date: dateStr);
    final homeAbbr = _teamIdToAbbr(localGame.homeTeamId);
    final awayAbbr = _teamIdToAbbr(localGame.awayTeamId);
    if (homeAbbr == null || awayAbbr == null) return null;

    for (final event in events) {
      final eHome = event.home.abbreviation.toUpperCase();
      final eAway = event.away.abbreviation.toUpperCase();
      if ((eHome == homeAbbr && eAway == awayAbbr) ||
          (eHome == awayAbbr && eAway == homeAbbr)) {
        return event;
      }
    }
    return null;
  }

  Future<OfficialResultSuggestion?> getOfficialSuggestion(Game localGame) async {
    final event = await findMatchingEvent(localGame);
    if (event == null) return null;

    final homeAbbr = _teamIdToAbbr(localGame.homeTeamId)?.toUpperCase();
    final isSameHome = event.home.abbreviation.toUpperCase() == homeAbbr;

    return OfficialResultSuggestion(
      eventId: event.id,
      homeScore: isSameHome ? event.home.score : event.away.score,
      awayScore: isSameHome ? event.away.score : event.home.score,
      status: event.status.type,
      statusDetail: event.status.shortDetail,
      isFinal: event.isCompleted,
      isInProgress: event.isInProgress,
    );
  }

  /// Obtiene standings oficiales y los convierte a un mapa teamId → record.
  Future<Map<String, EspnStandingEntry>> fetchOfficialStandings({
    int? season,
  }) async {
    final json = await _client.getStandings(season: season);
    final result = <String, EspnStandingEntry>{};

    final children = json['children'] as List<dynamic>? ?? [];
    for (final conf in children) {
      final confMap = conf as Map<String, dynamic>;
      final confAbbr = confMap['abbreviation']?.toString() ?? '';
      final standings = confMap['standings'] as Map<String, dynamic>? ?? {};
      final entries = standings['entries'] as List<dynamic>? ?? [];

      for (final entry in entries) {
        final e = entry as Map<String, dynamic>;
        final team = e['team'] as Map<String, dynamic>? ?? {};
        final abbr = team['abbreviation']?.toString().toUpperCase() ?? '';
        final displayName = team['displayName']?.toString() ?? '';
        final stats = e['stats'] as List<dynamic>? ?? [];

        int wins = 0, losses = 0, ties = 0;
        double winPct = 0;

        for (final s in stats) {
          final stat = s as Map<String, dynamic>;
          final name = stat['name']?.toString();
          final value = stat['value'];
          if (name == 'wins') wins = (value as num?)?.toInt() ?? 0;
          if (name == 'losses') losses = (value as num?)?.toInt() ?? 0;
          if (name == 'ties') ties = (value as num?)?.toInt() ?? 0;
          if (name == 'winPercent') winPct = (value as num?)?.toDouble() ?? 0;
        }

        final teamId = abbrToTeamId[abbr];
        if (teamId != null) {
          result[teamId] = EspnStandingEntry(
            abbreviation: abbr,
            displayName: displayName,
            wins: wins,
            losses: losses,
            ties: ties,
            winPercent: winPct,
            conference: confAbbr,
          );
        }
      }
    }
    return result;
  }

  String? _teamIdToAbbr(String teamId) {
    for (final e in abbrToTeamId.entries) {
      if (e.value == teamId) return e.key;
    }
    return null;
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  void dispose() => _client.dispose();
}

class OfficialResultSuggestion {
  final String eventId;
  final int homeScore;
  final int awayScore;
  final String status;
  final String statusDetail;
  final bool isFinal;
  final bool isInProgress;

  OfficialResultSuggestion({
    required this.eventId,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.statusDetail,
    required this.isFinal,
    required this.isInProgress,
  });

  GameResult toGameResult() =>
      GameResult(homeScore: homeScore, awayScore: awayScore);
}