import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../../domain/game/game.dart';

/// Servicio de notificaciones locales para recordatorios de partidos.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // Pedir permisos en Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Programa una notificación 1 día antes del partido (a las 10:00 locales).
  Future<void> scheduleGameReminder({
    required Game game,
    required String homeName,
    required String awayName,
  }) async {
    if (!_initialized) await init();

    final gameDate = game.scheduledAt;
    // Un día antes a las 10:00
    var reminder = DateTime(
      gameDate.year,
      gameDate.month,
      gameDate.day,
      10,
      0,
    ).subtract(const Duration(days: 1));

    // Si ya pasó, no programar
    if (reminder.isBefore(DateTime.now())) return;

    final id = _notificationId(game.id);

    await _plugin.zonedSchedule(
      id,
      'Partido mañana 🏈',
      '$awayName @ $homeName · ${_formatShort(gameDate)}',
      tz.TZDateTime.from(reminder, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'game_reminders',
          'Recordatorios de partidos',
          channelDescription: 'Avisos un día antes de los partidos',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: game.id,
    );
  }

  /// Programa recordatorios para una lista de partidos (solo los de tus equipos).
  Future<void> scheduleRemindersForGames({
    required List<Game> games,
    required Set<String> favoriteTeamIds,
    required String Function(String teamId) teamNameResolver,
  }) async {
    // Cancelar anteriores para evitar duplicados
    await cancelAllGameReminders();

    for (final game in games) {
      final isFavorite = favoriteTeamIds.contains(game.homeTeamId) ||
          favoriteTeamIds.contains(game.awayTeamId);
      if (!isFavorite) continue;
      if (game.status != GameStatus.scheduled) continue;

      await scheduleGameReminder(
        game: game,
        homeName: teamNameResolver(game.homeTeamId),
        awayName: teamNameResolver(game.awayTeamId),
      );
    }
  }

  Future<void> cancelGameReminder(String gameId) async {
    await _plugin.cancel(_notificationId(gameId));
  }

  Future<void> cancelAllGameReminders() async {
    await _plugin.cancelAll();
  }

  int _notificationId(String gameId) {
    // Hash simple y estable
    return gameId.hashCode & 0x7FFFFFFF;
  }

  String _formatShort(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month} $hh:$mm';
  }
}