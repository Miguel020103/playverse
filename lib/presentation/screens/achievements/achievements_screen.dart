import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../data/achievements/achievement_catalog.dart';
import '../../../domain/achievement/achievement.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  IconData _icon(String key) {
    switch (key) {
      case 'edit_note':
        return Icons.edit_note_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'sports_score':
        return Icons.sports_score_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'groups':
        return Icons.groups_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      default:
        return Icons.workspace_premium_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(unlockedAchievementsProvider);
    final unlockedIds = unlocked.map((u) => u.achievementId).toSet();
    final progress = ref.watch(achievementProgressProvider);
    final catalog = AchievementCatalog.all;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Logros',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: Colors.amber, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${progress.unlocked} / ${progress.total} desbloqueados',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sigue registrando resultados para conseguir más.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final a in catalog) ...[
            _AchievementCard(
              achievement: a,
              unlocked: unlockedIds.contains(a.id),
              icon: _icon(a.icon),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  final IconData icon;

  const _AchievementCard({
    required this.achievement,
    required this.unlocked,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.amber.withOpacity(0.08)
            : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? Colors.amber.withOpacity(0.35)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: unlocked ? Colors.amber : Colors.white24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.nameEs,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: unlocked ? Colors.white : Colors.white54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.descriptionEs,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(unlocked ? 0.5 : 0.28),
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle_rounded,
                color: Colors.amber, size: 22),
        ],
      ),
    );
  }
}
