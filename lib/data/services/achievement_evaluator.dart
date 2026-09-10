import '../../domain/achievement/achievement.dart';
import '../../domain/game/game.dart';
import '../../domain/standings/standing.dart';
import '../../domain/user/user.dart';
import '../achievements/achievement_catalog.dart';
import 'standings_calculator.dart';

class AchievementEvaluator {
  /// Returns newly unlocked achievement ids (not previously unlocked).
  static List<UnlockedAchievement> evaluate({
    required List<Game> games,
    required UserPreferences prefs,
    required List<UnlockedAchievement> already,
  }) {
    final unlockedIds = already.map((u) => u.achievementId).toSet();
    final now = DateTime.now();
    final fresh = <UnlockedAchievement>[];

    void unlock(String id, {String? teamId}) {
      if (unlockedIds.contains(id)) return;
      unlockedIds.add(id);
      fresh.add(UnlockedAchievement(
        achievementId: id,
        teamId: teamId,
        unlockedAt: now,
      ));
    }

    final completed = games.where((g) => g.isCompleted).toList();

    if (completed.isNotEmpty) unlock('first_result');
    if (completed.length >= 10) unlock('ten_games');

    if (prefs.secondTeamId != null) unlock('follower');

    for (final g in completed) {
      final r = g.result;
      if (r != null && (r.homeScore + r.awayScore) >= 50) {
        unlock('high_scoring');
        break;
      }
    }

    final mainId = prefs.mainTeamId;
    if (mainId != null) {
      final standings = StandingsCalculator.calculate(games);
      Standing? mainStanding;
      try {
        mainStanding = standings.firstWhere((s) => s.teamId == mainId);
      } catch (_) {
        mainStanding = null;
      }

      if (mainStanding != null) {
        if (mainStanding.wins >= 1) unlock('first_win', teamId: mainId);
        if (mainStanding.streakType == 'W' && mainStanding.currentStreak >= 3) {
          unlock('win_streak_3', teamId: mainId);
        }
        if (mainStanding.streakType == 'W' && mainStanding.currentStreak >= 4) {
          unlock('perfect_week', teamId: mainId);
        }
        if (mainStanding.rank == 1 && mainStanding.gamesPlayed > 0) {
          unlock('division_leader', teamId: mainId);
        }
      }
    }

    // validate catalog exists
    return fresh
        .where((u) => AchievementCatalog.byId(u.achievementId) != null)
        .toList();
  }
}
