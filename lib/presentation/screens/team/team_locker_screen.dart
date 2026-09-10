import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/games/games_provider.dart';
import '../../../application/standings/standings_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../core/theme/team_theme.dart';
import '../../../domain/game/game.dart';
import '../../../domain/team/team.dart';

class TeamLockerScreen extends ConsumerWidget {
  final String teamId;

  const TeamLockerScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamByIdProvider(teamId));
    final standing = ref.watch(teamStandingProvider(teamId));
    final games = ref
        .watch(gamesLiveProvider)
        .where((g) => g.homeTeamId == teamId || g.awayTeamId == teamId)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    if (team == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0C),
        body: Center(
          child: Text(
            'Equipo no encontrado',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final theme = TeamTheme.fromHex(
      primaryHex: team.primaryColor,
      secondaryHex: team.secondaryColor,
      tertiaryHex: team.tertiaryColor,
    );

    final completed = games.where((g) => g.isCompleted).toList();
    final upcoming =
        games.where((g) => g.status == GameStatus.scheduled).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: CustomScrollView(
        slivers: [
          // ── Header identidad ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primary.withOpacity(0.92),
                    theme.primary.withOpacity(0.42),
                    theme.secondary.withOpacity(0.28),
                    const Color(0xFF0A0A0C),
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 16, 28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: theme.onPrimary,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.secondary.withOpacity(0.28),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.secondary.withOpacity(0.55),
                              ),
                            ),
                            child: Text(
                              team.conferenceAndDivision,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: theme.onPrimary.withOpacity(0.92),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.secondary.withOpacity(0.75),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primary.withOpacity(0.5),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          team.logoAsset,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.sports_football,
                            size: 44,
                            color: theme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        team.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: theme.onPrimary,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team.city,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.onPrimary.withOpacity(0.65),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Record pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.38),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: theme.secondary.withOpacity(0.45),
                          ),
                        ),
                        child: Text(
                          standing != null && standing.gamesPlayed > 0
                              ? '${standing.record}  ·  ${(standing.winPercentage * 1000).round() / 10}%'
                              : '0-0  ·  Sin partidos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: theme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── SECCIÓN PRINCIPAL: Estadísticas ──────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: _SectionTitle('Estadísticas de temporada', accent: theme.secondary),
            ),
          ),

          if (standing == null || standing.gamesPlayed == 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.primary.withOpacity(0.18)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.insights_rounded,
                          color: theme.secondary.withOpacity(0.7), size: 32),
                      const SizedBox(height: 12),
                      const Text(
                        'Sin estadísticas todavía',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Registra resultados en Partidos para ver el rendimiento de este equipo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.4),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () => context.go('/games'),
                        child: Text(
                          'Ir a Partidos',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: theme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Big ranking + streak row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _BigStatCard(
                        label: 'Puesto división',
                        value: '#${standing.rank}',
                        accent: theme.primary,
                        highlight: standing.rank == 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BigStatCard(
                        label: 'Racha actual',
                        value: standing.streakDisplay,
                        accent: theme.secondary,
                        highlight: standing.streakType == 'W' &&
                            standing.currentStreak >= 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Core grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.25,
                  children: [
                    _StatTile('Victorias', '${standing.wins}',
                        accent: theme.primary),
                    _StatTile('Derrotas', '${standing.losses}',
                        accent: theme.primary),
                    _StatTile('Empates', '${standing.ties}',
                        accent: theme.primary),
                    _StatTile('PF', '${standing.pointsFor}',
                        accent: theme.primary),
                    _StatTile('PA', '${standing.pointsAgainst}',
                        accent: theme.primary),
                    _StatTile(
                      'DIFF',
                      standing.pointDifferential >= 0
                          ? '+${standing.pointDifferential}'
                          : '${standing.pointDifferential}',
                      accent: theme.primary,
                      valueColor: standing.pointDifferential > 0
                          ? Colors.greenAccent
                          : standing.pointDifferential < 0
                              ? Colors.redAccent
                              : null,
                    ),
                  ],
                ),
              ),
            ),

            // Context records
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: _SectionTitle('Desglose', accent: theme.secondary),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    _RecordRow(
                      label: 'Local',
                      value: standing.homeRecord,
                      accent: theme.primary,
                    ),
                    _RecordRow(
                      label: 'Visitante',
                      value: standing.awayRecord,
                      accent: theme.primary,
                    ),
                    _RecordRow(
                      label: 'División',
                      value: standing.divisionRecord,
                      accent: theme.secondary,
                    ),
                    _RecordRow(
                      label: 'Conferencia',
                      value: standing.conferenceRecord,
                      accent: theme.secondary,
                    ),
                    _RecordRow(
                      label: 'Últimos 5',
                      value: standing.last5Display,
                      accent: theme.secondary,
                    ),
                    _RecordRow(
                      label: 'Jugados',
                      value: '${standing.gamesPlayed}',
                      accent: theme.primary,
                    ),
                  ],
                ),
              ),
            ),

            // Scoring averages
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: _SectionTitle('Promedios', accent: theme.secondary),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _BigStatCard(
                        label: 'Pts a favor / partido',
                        value: standing.gamesPlayed == 0
                            ? '—'
                            : (standing.pointsFor / standing.gamesPlayed)
                                .toStringAsFixed(1),
                        accent: theme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BigStatCard(
                        label: 'Pts en contra / partido',
                        value: standing.gamesPlayed == 0
                            ? '—'
                            : (standing.pointsAgainst / standing.gamesPlayed)
                                .toStringAsFixed(1),
                        accent: theme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── SECCIÓN SECUNDARIA: Partidos (resumen corto) ─────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _SectionTitle('Actividad reciente',
                        accent: Colors.white38),
                  ),
                  TextButton(
                    onPressed: () => context.go('/games'),
                    child: Text(
                      'Ver calendario',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: theme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mini recent results only (max 3)
          if (completed.isEmpty && upcoming.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sin partidos registrados aún.',
                  style: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            )
          else ...[
            if (completed.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final g = completed.reversed.toList()[i];
                    final isHome = g.homeTeamId == teamId;
                    final oppId = isHome ? g.awayTeamId : g.homeTeamId;
                    final opp = ref.watch(teamByIdProvider(oppId));
                    if (opp == null || g.result == null) {
                      return const SizedBox.shrink();
                    }
                    final mine =
                        isHome ? g.result!.homeScore : g.result!.awayScore;
                    final theirs =
                        isHome ? g.result!.awayScore : g.result!.homeScore;
                    final won = mine > theirs;
                    final tied = mine == theirs;
                    return _ResultTile(
                      opponent: opp,
                      mine: mine,
                      theirs: theirs,
                      isHome: isHome,
                      won: won,
                      tied: tied,
                      teamTheme: theme,
                    );
                  },
                  childCount: completed.take(3).length,
                ),
              ),
            if (upcoming.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Próximo: ${upcoming.first.homeTeamId == teamId ? 'vs' : '@'} ${_abbr(ref, upcoming.first.homeTeamId == teamId ? upcoming.first.awayTeamId : upcoming.first.homeTeamId)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.45),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  String _abbr(WidgetRef ref, String teamId) {
    return ref.read(teamByIdProvider(teamId))?.abbreviation ?? '—';
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color accent;

  const _SectionTitle(this.text, {required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _BigStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final bool highlight;

  const _BigStatCard({
    required this.label,
    required this.value,
    required this.accent,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: accent.withOpacity(highlight ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.withOpacity(highlight ? 0.45 : 0.18),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: highlight ? accent : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final Color? valueColor;

  const _StatTile(
    this.label,
    this.value, {
    required this.accent,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accent.withOpacity(0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: valueColor ?? Colors.white,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _RecordRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final Team opponent;
  final int mine;
  final int theirs;
  final bool isHome;
  final bool won;
  final bool tied;
  final TeamTheme teamTheme;

  const _ResultTile({
    required this.opponent,
    required this.mine,
    required this.theirs,
    required this.isHome,
    required this.won,
    required this.tied,
    required this.teamTheme,
  });

  @override
  Widget build(BuildContext context) {
    final resultColor =
        tied ? Colors.amber : (won ? Colors.greenAccent : Colors.redAccent);
    final resultLetter = tied ? 'T' : (won ? 'W' : 'L');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: resultColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            resultLetter,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: resultColor,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          '${isHome ? 'vs' : '@'} ${opponent.abbreviation}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        trailing: Text(
          '$mine - $theirs',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: teamTheme.secondary.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
