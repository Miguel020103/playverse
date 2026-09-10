import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/espn_score_service.dart';
import '../../domain/game/game.dart';
import '../../data/repositories/game_repository.dart';

/// Provider del servicio ESPN (singleton).
final espnScoreServiceProvider = Provider<EspnScoreService>((ref) {
  final service = EspnScoreService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider del repositorio de juegos (ajusta si ya tienes uno).
final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository();
});

/// Estado de una sugerencia de resultado oficial.
class OfficialSuggestionState {
  final bool isLoading;
  final OfficialResultSuggestion? suggestion;
  final String? error;

  const OfficialSuggestionState({
    this.isLoading = false,
    this.suggestion,
    this.error,
  });

  OfficialSuggestionState copyWith({
    bool? isLoading,
    OfficialResultSuggestion? suggestion,
    String? error,
  }) {
    return OfficialSuggestionState(
      isLoading: isLoading ?? this.isLoading,
      suggestion: suggestion ?? this.suggestion,
      error: error,
    );
  }
}

/// Provider que obtiene la sugerencia oficial para un Game concreto.
final officialSuggestionProvider = StateNotifierProvider.family<
    OfficialSuggestionNotifier, OfficialSuggestionState, Game>(
  (ref, game) {
    return OfficialSuggestionNotifier(
      ref.watch(espnScoreServiceProvider),
      game,
    );
  },
);

class OfficialSuggestionNotifier
    extends StateNotifier<OfficialSuggestionState> {
  OfficialSuggestionNotifier(this._service, this._game)
      : super(const OfficialSuggestionState()) {
    // Carga automática al crearse
    load();
  }

  final EspnScoreService _service;
  final Game _game;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final suggestion = await _service.getOfficialSuggestion(_game);
      state = OfficialSuggestionState(
        isLoading: false,
        suggestion: suggestion,
      );
    } catch (e) {
      state = OfficialSuggestionState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() => load();
}