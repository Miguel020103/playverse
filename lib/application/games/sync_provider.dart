import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/game_repository.dart';
import '../../data/services/espn_score_service.dart';
import '../../data/services/sync_service.dart';

final espnScoreServiceProvider = Provider<EspnScoreService>((ref) {
  final service = EspnScoreService();
  ref.onDispose(service.dispose);
  return service;
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    espnService: ref.watch(espnScoreServiceProvider),
    gameRepository: ref.watch(gameRepositoryProvider),
  );
});

/// Estado de sincronización.
class SyncState {
  final bool isSyncing;
  final int? lastUpdatedCount;
  final String? error;

  const SyncState({
    this.isSyncing = false,
    this.lastUpdatedCount,
    this.error,
  });

  SyncState copyWith({
    bool? isSyncing,
    int? lastUpdatedCount,
    String? error,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastUpdatedCount: lastUpdatedCount ?? this.lastUpdatedCount,
      error: error,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier(this._syncService) : super(const SyncState());

  final SyncService _syncService;

  Future<void> syncWeek(int year, int week) async {
    state = state.copyWith(isSyncing: true, error: null);
    try {
      final count = await _syncService.syncWeekResults(year: year, week: week);
      state = SyncState(isSyncing: false, lastUpdatedCount: count);
    } catch (e) {
      state = SyncState(isSyncing: false, error: e.toString());
    }
  }
}

final syncNotifierProvider =
    StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncServiceProvider));
});