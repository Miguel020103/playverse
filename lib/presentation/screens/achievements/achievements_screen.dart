import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../data/achievements/achievement_catalog.dart';
import '../../widgets/achievement_progress_card.dart';

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
    final progressRatio =
        progress.total == 0 ? 0.0 : progress.unlocked / progress.total;

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
          // Header con progreso global
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.15),
                  Colors.amber.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: Colors.amber, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${progress.unlocked} / ${progress.total}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'logros desbloqueados',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(Colors.amber),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lista de logros con progreso
          for (final a in catalog) ...[
            AchievementProgressCard(
              title: a.nameEs,
              description: a.descriptionEs,
              icon: _icon(a.icon),
              unlocked: unlockedIds.contains(a.id),
              // Progreso individual simple (0 o 1). 
              // Puedes mejorar esto con lógica real por tipo de logro.
              progress: unlockedIds.contains(a.id) ? 1.0 : 0.0,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}