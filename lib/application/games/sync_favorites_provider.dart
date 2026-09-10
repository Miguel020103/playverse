import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/espn_score_service.dart';
import '../../data/services/sync_favorites_service.dart';
import '../user/user_provider.dart';
import 'games_provider.dart';

final espnScoreServiceProvider = Provider<EspnScoreService>((ref) {
  final service = EspnScoreService();
  ref.onDispose(service.dispose);
  return service;
});

final syncFavoritesServiceProvider = Provider<SyncFavoritesService>((ref) {
  return SyncFavoritesService(
    espnService: ref.watch(espnScoreServiceProvider),
    gameRepository: ref.watch(gameRepositoryProvider),
  );
});

class SyncFavoritesState {
  final bool isSyncing;
  final int? updatedCount;
  final String? error;

  const SyncFavoritesState({
    this.isSyncing = false,
    this.updatedCount,
    this.error,
  });
}

class SyncFavoritesNotifier extends StateNotifier<SyncFavoritesState> {
  SyncFavoritesNotifier(this._ref) : super(const SyncFavoritesState());

  final Ref _ref;

  Future<void> sync() async {
    state = const SyncFavoritesState(isSyncing: true);

    try {
      final userPrefs = _ref.read(userPreferencesProvider);
      final favoriteIds = <String>{};
      if (userPrefs.mainTeamId != null) favoriteIds.add(userPrefs.mainTeamId!);
      if (userPrefs.secondTeamId != null) favoriteIds.add(userPrefs.secondTeamId!);
      favoriteIds.addAll(userPrefs.followedTeamIds);

      final games = _ref.read(gamesLiveProvider);
      final service = _ref.read(syncFavoritesServiceProvider);

      final count = await service.syncFavorites(
        games: games,
        favoriteTeamIds: favoriteIds,
      );

      // Forzar refresh de la lista
      _ref.read(gameResultsVersionProvider.notifier).state++;

      state = SyncFavoritesState(isSyncing: false, updatedCount: count);
    } catch (e) {
      state = SyncFavoritesState(isSyncing: false, error: e.toString());
    }
  }
}

final syncFavoritesProvider =
    StateNotifierProvider<SyncFavoritesNotifier, SyncFavoritesState>((ref) {
  return SyncFavoritesNotifier(ref);
});