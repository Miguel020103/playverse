import '../../domain/game/game.dart';
import '../repositories/game_repository.dart';
import 'espn_score_service.dart';

/// Sincroniza resultados oficiales de ESPN con el repositorio local.
class SyncService {
  SyncService({
    required this.espnService,
    required this.gameRepository,
  });

  final EspnScoreService espnService;
  final GameRepository gameRepository;

  /// Sincroniza todos los partidos de una semana que ya hayan terminado.
  /// Devuelve cuántos resultados nuevos se guardaron.
  Future<int> syncWeekResults({
    required int year,
    required int week,
  }) async {
    final events = await espnService.fetchScoreboardByWeek(
      year: year,
      week: week,
    );

    final localGames = gameRepository.getAllGames();
    int updated = 0;

    for (final event in events) {
      if (!event.isCompleted) continue;

      // Buscar partido local que coincida por abreviaturas
      final homeAbbr = event.home.abbreviation.toUpperCase();
      final awayAbbr = event.away.abbreviation.toUpperCase();

      final match = localGames.where((g) {
        final h = EspnScoreService.abbrToTeamId[homeAbbr];
        final a = EspnScoreService.abbrToTeamId[awayAbbr];
        if (h == null || a == null) return false;
        return (g.homeTeamId == h && g.awayTeamId == a) ||
            (g.homeTeamId == a && g.awayTeamId == h);
      }).toList();

      if (match.isEmpty) continue;
      final game = match.first;

      // Solo actualizar si no tiene resultado manual o queremos forzar oficial
      if (game.isCompleted && game.source == DataSourceType.manual) {
        // Opcional: no sobrescribir manuales. Cambia según preferencia.
        continue;
      }

      final isSameHome = game.homeTeamId ==
          EspnScoreService.abbrToTeamId[homeAbbr];

      final homeScore = isSameHome ? event.home.score : event.away.score;
      final awayScore = isSameHome ? event.away.score : event.home.score;

      await gameRepository.saveResult(
        gameId: game.id,
        homeScore: homeScore,
        awayScore: awayScore,
      );
      updated++;
    }

    return updated;
  }

  /// Sincroniza solo los partidos de los equipos favoritos del usuario.
  Future<int> syncFavoriteTeamsResults({
    required List<Game> games,
    required Set<String> favoriteTeamIds,
  }) async {
    int updated = 0;

    for (final game in games) {
      final isFav = favoriteTeamIds.contains(game.homeTeamId) ||
          favoriteTeamIds.contains(game.awayTeamId);
      if (!isFav) continue;
      if (game.isCompleted) continue;

      final suggestion = await espnService.getOfficialSuggestion(game);
      if (suggestion == null || !suggestion.isFinal) continue;

      await gameRepository.saveResult(
        gameId: game.id,
        homeScore: suggestion.homeScore,
        awayScore: suggestion.awayScore,
      );
      updated++;
    }

    return updated;
  }
}