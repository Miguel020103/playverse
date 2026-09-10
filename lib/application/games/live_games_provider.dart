import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/espn_score_service.dart';
import '../../domain/game/game.dart';

/// Mapa de gameId → sugerencia en vivo / final desde ESPN.
/// Se puede refrescar manualmente o periódicamente.
final liveSuggestionsProvider =
    StateNotifierProvider<LiveSuggestionsNotifier, Map<String, OfficialResultSuggestion>>((ref) {
  return LiveSuggestionsNotifier(ref);
});

class LiveSuggestionsNotifier extends StateNotifier<Map<String, OfficialResultSuggestion>> {
  LiveSuggestionsNotifier(this._ref) : super({});

  final Ref _ref;

  /// Carga sugerencias para los partidos de la semana indicada (o favoritos).
  Future<void> refreshForGames(List<Game> games) async {
    final service = EspnScoreService();
    final result = <String, OfficialResultSuggestion>{};

    // Limitamos a no hacer demasiadas peticiones
    final toCheck = games.take(12).toList();

    for (final game in toCheck) {
      try {
        final suggestion = await service.getOfficialSuggestion(game);
        if (suggestion != null) {
          result[game.id] = suggestion;
        }
      } catch (_) {}
    }

    service.dispose();
    state = result;
  }

  OfficialResultSuggestion? getFor(String gameId) => state[gameId];
}

/// Helper: ¿este partido está en vivo según ESPN?
final isGameLiveProvider = Provider.family<bool, String>((ref, gameId) {
  final suggestion = ref.watch(liveSuggestionsProvider)[gameId];
  return suggestion?.isInProgress == true;
});