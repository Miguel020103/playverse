import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../application/games/games_provider.dart';
import '../../../application/standings/standings_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../core/theme/team_theme.dart';
import '../../../domain/game/game.dart';
import '../../../domain/team/team.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final main = ref.watch(mainTeamProvider);
    final second = ref.watch(secondTeamProvider);
    final upcoming = ref.watch(followedUpcomingGamesProvider);
    final progress = ref.watch(achievementProgressProvider);
    final standing =
        main != null ? ref.watch(teamStandingProvider(main.id)) : null;

    final theme = main != null
        ? TeamTheme.fromHex(
            primaryHex: main.primaryColor,
            secondaryHex: main.secondaryColor,
          )
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLAYVERSE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Inicio',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logo small
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 36,
                          height: 36,
                          color: Colors.white12,
                          child: const Icon(Icons.sports, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main team hero
            if (main != null && theme != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: InkWell(
                    onTap: () => context.push('/team/${main.id}'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primary.withOpacity(0.85),
                            theme.secondary.withOpacity(0.35),
                            const Color(0xFF0A0A0C),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.secondary.withOpacity(0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.secondary.withOpacity(0.6),
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              main.logoAsset,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.sports_football,
                                color: theme.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  main.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                    color: theme.onPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  standing != null && standing.gamesPlayed > 0
                                      ? '${standing.record}  ·  ${main.conferenceAndDivision}'
                                      : main.conferenceAndDivision,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.onPrimary.withOpacity(0.7),
                                  ),
                                ),
                                if (standing != null &&
                                    standing.currentStreak > 0) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Racha ${standing.streakDisplay}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: theme.secondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.onPrimary.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: _EmptyCard(
                    title: 'Elige tu equipo principal',
                    subtitle:
                        'Personaliza Home con los colores y stats de tu equipo.',
                    action: 'Ir a equipos',
                    onTap: () => context.go('/more'),
                  ),
                ),
              ),

            // Quick actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.sports_football_rounded,
                        label: 'Partidos',
                        onTap: () => context.go('/games'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.leaderboard_rounded,
                        label: 'Clasificación',
                        onTap: () => context.go('/divisions'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.emoji_events_rounded,
                        label: 'Logros',
                        badge: '${progress.unlocked}',
                        onTap: () => context.push('/achievements'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Upcoming
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    const Text(
                      'Próximos partidos',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go('/games'),
                      child: const Text(
                        'Ver todos',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (upcoming.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _EmptyCard(
                    title: 'Sin próximos partidos',
                    subtitle:
                        'Cuando haya partidos de tus equipos aparecerán aquí.',
                    action: 'Ver temporada',
                    onTap: () => context.go('/games'),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final g = upcoming[i];
                    final home = ref.watch(teamByIdProvider(g.homeTeamId));
                    final away = ref.watch(teamByIdProvider(g.awayTeamId));
                    if (home == null || away == null) {
                      return const SizedBox.shrink();
                    }
                    return _UpcomingTile(game: g, home: home, away: away);
                  },
                  childCount: upcoming.take(5).length,
                ),
              ),

            if (second != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Segundo equipo',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        onTap: () => context.push('/team/${second.id}'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        tileColor: Colors.white.withOpacity(0.04),
                        leading: Image.asset(
                          second.logoAsset,
                          width: 36,
                          height: 36,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.sports_football),
                        ),
                        title: Text(
                          second.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          second.conferenceAndDivision,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: Colors.white, size: 22),
                  if (badge != null)
                    Positioned(
                      right: -10,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;

  const _EmptyCard({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              action,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  final Game game;
  final Team home;
  final Team away;

  const _UpcomingTile({
    required this.game,
    required this.home,
    required this.away,
  });

  @override
  Widget build(BuildContext context) {
    final d = game.scheduledAt;
    final date =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${away.abbreviation} @ ${home.abbreviation}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}
