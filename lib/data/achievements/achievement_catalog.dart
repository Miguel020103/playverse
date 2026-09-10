import '../../domain/achievement/achievement.dart';

class AchievementCatalog {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_result',
      name: 'First Score',
      nameEs: 'Primer marcador',
      description: 'Record your first game result.',
      descriptionEs: 'Registra el resultado de tu primer partido.',
      category: 'progress',
      icon: 'edit_note',
    ),
    Achievement(
      id: 'first_win',
      name: 'First Win',
      nameEs: 'Primera victoria',
      description: 'Your main team wins a game.',
      descriptionEs: 'Tu equipo principal gana un partido.',
      category: 'performance',
      icon: 'emoji_events',
    ),
    Achievement(
      id: 'win_streak_3',
      name: 'On Fire',
      nameEs: 'En racha',
      description: 'Main team wins 3 in a row.',
      descriptionEs: 'Tu equipo principal gana 3 seguidos.',
      category: 'performance',
      icon: 'local_fire_department',
    ),
    Achievement(
      id: 'division_leader',
      name: 'Division Leader',
      nameEs: 'Líder de división',
      description: 'Main team ranks #1 in its division.',
      descriptionEs: 'Tu equipo principal lidera su división.',
      category: 'competition',
      icon: 'military_tech',
    ),
    Achievement(
      id: 'ten_games',
      name: 'Scorekeeper',
      nameEs: 'Anotador',
      description: 'Record 10 game results.',
      descriptionEs: 'Registra 10 resultados de partidos.',
      category: 'progress',
      icon: 'sports_score',
    ),
    Achievement(
      id: 'perfect_week',
      name: 'Perfect Week',
      nameEs: 'Semana perfecta',
      description: 'Main team wins all games in a completed week (tracked via streak).',
      descriptionEs: 'Tu equipo gana de forma sostenida en la temporada.',
      category: 'performance',
      icon: 'star',
    ),
    Achievement(
      id: 'follower',
      name: 'Two Squads',
      nameEs: 'Dos equipos',
      description: 'Select a second team.',
      descriptionEs: 'Selecciona un segundo equipo.',
      category: 'progress',
      icon: 'groups',
    ),
    Achievement(
      id: 'high_scoring',
      name: 'Shootout',
      nameEs: 'Festival de puntos',
      description: 'Record a game with 50+ combined points.',
      descriptionEs: 'Registra un partido con 50+ puntos combinados.',
      category: 'performance',
      icon: 'bolt',
    ),
  ];

  static Achievement? byId(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
