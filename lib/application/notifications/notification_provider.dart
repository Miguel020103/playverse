import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/notification_service.dart';
import '../games/games_provider.dart';
import '../teams/teams_provider.dart';
import '../user/user_provider.dart'; // ← aquí está userPreferencesProvider

/// Provider del servicio de notificaciones.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// Programa (o reprograma) los recordatorios de partidos de los equipos favoritos.
final scheduleGameRemindersProvider = FutureProvider.autoDispose<void>((ref) async {
  final notificationService = ref.read(notificationServiceProvider);
  final games = ref.read(gamesLiveProvider);
  final userPrefs = ref.read(userPreferencesProvider);

  // Equipos favoritos del usuario
  final favoriteIds = <String>{};
  if (userPrefs.mainTeamId != null) {
    favoriteIds.add(userPrefs.mainTeamId!);
  }
  if (userPrefs.secondTeamId != null) {
    favoriteIds.add(userPrefs.secondTeamId!);
  }

  // También incluimos followedTeamIds por si los usas
  favoriteIds.addAll(userPrefs.followedTeamIds);

  String resolveName(String teamId) {
    final team = ref.read(teamByIdProvider(teamId));
    return team?.shortName ?? teamId;
  }

  await notificationService.scheduleRemindersForGames(
    games: games,
    favoriteTeamIds: favoriteIds,
    teamNameResolver: resolveName,
  );
});