import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/achievements/achievement_catalog.dart';
import '../../data/local/hive/hive_boxes.dart';
import '../../data/services/achievement_evaluator.dart';
import '../../domain/achievement/achievement.dart';
import '../games/games_provider.dart';
import '../user/user_provider.dart';

const _unlockKey = 'unlocked_achievements';

List<UnlockedAchievement> _loadUnlocked() {
  final raw = HiveBoxes.seasonBox.get(_unlockKey);
  if (raw == null) return [];
  final list = (raw as List).cast<dynamic>();
  return list
      .map((e) => UnlockedAchievement.fromMap(Map<dynamic, dynamic>.from(e as Map)))
      .toList();
}

Future<void> _saveUnlocked(List<UnlockedAchievement> list) async {
  await HiveBoxes.seasonBox.put(
    _unlockKey,
    list.map((e) => e.toMap()).toList(),
  );
}

final unlockedAchievementsProvider =
    StateNotifierProvider<UnlockedAchievementsNotifier, List<UnlockedAchievement>>(
  (ref) => UnlockedAchievementsNotifier(ref),
);

class UnlockedAchievementsNotifier
    extends StateNotifier<List<UnlockedAchievement>> {
  final Ref _ref;

  UnlockedAchievementsNotifier(this._ref) : super(_loadUnlocked()) {
    // evaluate on start
    Future.microtask(evaluate);
  }

  Future<void> evaluate() async {
    final games = _ref.read(gamesLiveProvider);
    final prefs = _ref.read(userPreferencesProvider);
    final fresh = AchievementEvaluator.evaluate(
      games: games,
      prefs: prefs,
      already: state,
    );
    if (fresh.isEmpty) return;
    final next = [...state, ...fresh];
    state = next;
    await _saveUnlocked(next);
  }
}

final achievementsCatalogProvider = Provider<List<Achievement>>((ref) {
  return AchievementCatalog.all;
});

final achievementProgressProvider = Provider<({int unlocked, int total})>((ref) {
  final unlocked = ref.watch(unlockedAchievementsProvider).length;
  final total = AchievementCatalog.all.length;
  return (unlocked: unlocked, total: total);
});
