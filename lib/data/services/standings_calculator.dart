import '../../domain/game/game.dart';
import '../../domain/standings/standing.dart';
import '../../domain/team/team.dart';
import '../nfl/nfl_teams.dart';

/// Calculates standings from completed games according to NFL rules.
/// Supports division, conference and overall rankings for wild-card context.
class StandingsCalculator {
  static const seasonId = 'nfl_2026';

  /// Returns standings for every team, ranked inside their division by default.
  static List<Standing> calculate(List<Game> games) {
    final completed = games.where((g) => g.isCompleted).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final Map<String, _TeamAccumulator> acc = {};
    for (final t in NflTeams.all) {
      acc[t.id] = _TeamAccumulator(t);
    }

    for (final g in completed) {
      final home = acc[g.homeTeamId];
      final away = acc[g.awayTeamId];
      if (home == null || away == null || g.result == null) continue;

      final hr = g.result!.homeScore;
      final ar = g.result!.awayScore;
      final isDiv = home.team.divisionId == away.team.divisionId;
      final isConf = home.team.conferenceId == away.team.conferenceId;

      if (hr > ar) {
        home.addWin(pointsFor: hr, pointsAgainst: ar, isHome: true, isDiv: isDiv, isConf: isConf);
        away.addLoss(pointsFor: ar, pointsAgainst: hr, isHome: false, isDiv: isDiv, isConf: isConf);
      } else if (ar > hr) {
        away.addWin(pointsFor: ar, pointsAgainst: hr, isHome: false, isDiv: isDiv, isConf: isConf);
        home.addLoss(pointsFor: hr, pointsAgainst: ar, isHome: true, isDiv: isDiv, isConf: isConf);
      } else {
        home.addTie(pointsFor: hr, pointsAgainst: ar, isHome: true, isDiv: isDiv, isConf: isConf);
        away.addTie(pointsFor: ar, pointsAgainst: hr, isHome: false, isDiv: isDiv, isConf: isConf);
      }
    }

    // Build base standings
    final all = acc.values.map((a) => a.toStanding()).toList();

    // Rank inside each division
    final byDiv = <String, List<Standing>>{};
    for (final s in all) {
      final div = NflTeams.byId(s.teamId)?.divisionId ?? 'unknown';
      byDiv.putIfAbsent(div, () => []).add(s);
    }

    final ranked = <Standing>[];
    for (final entry in byDiv.entries) {
      final list = entry.value;
      list.sort(_compareStandings);
      for (var i = 0; i < list.length; i++) {
        ranked.add(list[i].copyWith(rank: i + 1, context: 'division'));
      }
    }

    return ranked;
  }

  /// Conference standings (for wild-card seeding context).
  static List<Standing> calculateConference(List<Game> games, String conferenceId) {
    final all = calculate(games);
    final conf = all.where((s) {
      final t = NflTeams.byId(s.teamId);
      return t?.conferenceId == conferenceId;
    }).toList();
    conf.sort(_compareStandings);
    return [
      for (var i = 0; i < conf.length; i++)
        conf[i].copyWith(rank: i + 1, context: 'conference'),
    ];
  }

  /// Simple comparator: win% → head-to-head (approx by differential) → division record → PF
  static int _compareStandings(Standing a, Standing b) {
    // 1. Win percentage
    final cmpPct = b.winPercentage.compareTo(a.winPercentage);
    if (cmpPct != 0) return cmpPct;

    // 2. Point differential
    final cmpDiff = b.pointDifferential.compareTo(a.pointDifferential);
    if (cmpDiff != 0) return cmpDiff;

    // 3. Points for
    final cmpPf = b.pointsFor.compareTo(a.pointsFor);
    if (cmpPf != 0) return cmpPf;

    // 4. Division wins
    return b.divisionWins.compareTo(a.divisionWins);
  }
}

class _TeamAccumulator {
  final Team team;
  int wins = 0, losses = 0, ties = 0;
  int pf = 0, pa = 0;
  int hW = 0, hL = 0, hT = 0;
  int aW = 0, aL = 0, aT = 0;
  int dW = 0, dL = 0, dT = 0;
  int cW = 0, cL = 0, cT = 0;
  final List<String> results = []; // 'W' | 'L' | 'T' chronological

  _TeamAccumulator(this.team);

  void addWin({
    required int pointsFor,
    required int pointsAgainst,
    required bool isHome,
    required bool isDiv,
    required bool isConf,
  }) {
    wins++;
    pf += pointsFor;
    pa += pointsAgainst;
    results.add('W');
    if (isHome) {
      hW++;
    } else {
      aW++;
    }
    if (isDiv) dW++;
    if (isConf) cW++;
  }

  void addLoss({
    required int pointsFor,
    required int pointsAgainst,
    required bool isHome,
    required bool isDiv,
    required bool isConf,
  }) {
    losses++;
    pf += pointsFor;
    pa += pointsAgainst;
    results.add('L');
    if (isHome) {
      hL++;
    } else {
      aL++;
    }
    if (isDiv) dL++;
    if (isConf) cL++;
  }

  void addTie({
    required int pointsFor,
    required int pointsAgainst,
    required bool isHome,
    required bool isDiv,
    required bool isConf,
  }) {
    ties++;
    pf += pointsFor;
    pa += pointsAgainst;
    results.add('T');
    if (isHome) {
      hT++;
    } else {
      aT++;
    }
    if (isDiv) dT++;
    if (isConf) cT++;
  }

  Standing toStanding() {
    // Current streak
    int streak = 0;
    String streakType = '';
    if (results.isNotEmpty) {
      streakType = results.last;
      for (var i = results.length - 1; i >= 0; i--) {
        if (results[i] == streakType) {
          streak++;
        } else {
          break;
        }
      }
    }

    // Last 5
    final last5 = results.length > 5 ? results.sublist(results.length - 5) : results;
    int l5w = 0, l5l = 0, l5t = 0;
    for (final r in last5) {
      if (r == 'W') l5w++;
      if (r == 'L') l5l++;
      if (r == 'T') l5t++;
    }

    return Standing(
      teamId: team.id,
      seasonId: StandingsCalculator.seasonId,
      wins: wins,
      losses: losses,
      ties: ties,
      pointsFor: pf,
      pointsAgainst: pa,
      homeWins: hW,
      homeLosses: hL,
      homeTies: hT,
      awayWins: aW,
      awayLosses: aL,
      awayTies: aT,
      divisionWins: dW,
      divisionLosses: dL,
      divisionTies: dT,
      conferenceWins: cW,
      conferenceLosses: cL,
      conferenceTies: cT,
      currentStreak: streak,
      streakType: streakType,
      last5Wins: l5w,
      last5Losses: l5l,
      last5Ties: l5t,
    );
  }
}
