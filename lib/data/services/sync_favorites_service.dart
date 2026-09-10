import '../../domain/game/game.dart';
import '../repositories/game_repository.dart';
import 'espn_score_service.dart';

/// Sincroniza resultados oficiales solo de los equipos favoritos del usuario.
class SyncFavoritesService {
  SyncFavoritesService({
    required this.espnService,
    required this.gameRepository,
  });

  final EspnScoreService espnService;
  final GameRepository gameRepository;

  /// Devuelve cuántos partidos se actualizaron.
  Future<int> syncFavorites({
    required List<Game> games,
    required Set<String> favoriteTeamIds,
  }) async {
    if (favoriteTeamIds.isEmpty) return 0;

    int updated = 0;

    final candidates = games.where((g) {
      final isFav = favoriteTeamIds.contains(g.homeTeamId) ||
          favoriteTeamIds.contains(g.awayTeamId);
      // Solo intentamos los que aún no están completados o son manuales
      return isFav && (!g.isCompleted || g.source == DataSourceType.manual);
    }).toList();

    for (final game in candidates) {
      try {
        final suggestion = await espnService.getOfficialSuggestion(game);
        if (suggestion == null || !suggestion.isFinal) continue;

        await gameRepository.saveResult(
          gameId: game.id,
          homeScore: suggestion.homeScore,
          awayScore: suggestion.awayScore,
        );
        // Nota: idealmente el repositorio también debería guardar source = remote
        updated++;
      } catch (_) {
        // Continuamos con el siguiente partido si uno falla
      }
    }

    return updated;
  }
}