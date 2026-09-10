import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../application/games/games_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../core/utils/color_utils.dart';
import '../../../domain/game/game.dart';
import '../../../domain/team/team.dart';

String _formatDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
  const months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];
  final day = days[(d.weekday - 1) % 7];
  final month = months[d.month - 1];
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '$day ${d.day} $month · $hh:$mm';
}

class GamesScreen extends ConsumerStatefulWidget {
  const GamesScreen({super.key});

  @override
  ConsumerState<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends ConsumerState<GamesScreen> {
  int _selectedWeek = 1;

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gamesLiveProvider);
    final weekGames = games.where((g) => g.id.startsWith('w$_selectedWeek')).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final completedCount = weekGames.where((g) => g.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TEMPORADA 2026',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Partidos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Registra resultados y sigue toda la temporada 2026.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            // Week selector
            SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 18,
                itemBuilder: (context, i) {
                  final week = i + 1;
                  final selected = week == _selectedWeek;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        'W$week',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: selected ? Colors.black : Colors.white70,
                        ),
                      ),
                      selected: selected,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.06),
                      onSelected: (_) => setState(() => _selectedWeek = week),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Text(
                    'Week $_selectedWeek',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$completedCount / ${weekGames.length} finalizados',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: weekGames.isEmpty
                  ? Center(
                      child: Text(
                        'Sin partidos esta semana',
                        style: TextStyle(color: Colors.white.withOpacity(0.35)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      itemCount: weekGames.length,
                      itemBuilder: (context, i) {
                        final g = weekGames[i];
                        final home = ref.watch(teamByIdProvider(g.homeTeamId));
                        final away = ref.watch(teamByIdProvider(g.awayTeamId));
                        if (home == null || away == null) return const SizedBox.shrink();
                        return _GameCard(
                          game: g,
                          home: home,
                          away: away,
                          onTap: () => _showResultSheet(context, ref, g, home, away),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultSheet(
    BuildContext context,
    WidgetRef ref,
    Game game,
    Team home,
    Team away,
  ) {
    final homeCtrl = TextEditingController(
      text: game.result?.homeScore.toString() ?? '',
    );
    final awayCtrl = TextEditingController(
      text: game.result?.awayScore.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141418),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                game.isCompleted ? 'Editar resultado' : 'Registrar resultado',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(game.scheduledAt),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 24),
              _TeamScoreRow(
                team: home,
                score: game.result?.homeScore,
                isHome: true,
              ),
              const SizedBox(height: 12),
              _TeamScoreRow(
                team: away,
                score: game.result?.awayScore,
                isHome: false,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: homeCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      decoration: _scoreDecoration(home.abbreviation),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '—',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: awayCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                      decoration: _scoreDecoration(away.abbreviation),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final hs = int.tryParse(homeCtrl.text.trim());
                    final as_ = int.tryParse(awayCtrl.text.trim());
                    if (hs == null || as_ == null || hs < 0 || as_ < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Introduce marcadores válidos'),
                        ),
                      );
                      return;
                    }
                    await ref.read(saveGameResultProvider)(
                      gameId: game.id,
                      homeScore: hs,
                      awayScore: as_,
                    );
                    await ref.read(unlockedAchievementsProvider.notifier).evaluate();
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Resultado guardado'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Guardar resultado',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ),
              ),
              if (game.isCompleted) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () async {
                      await ref.read(clearGameResultProvider)(gameId: game.id);
                      await ref.read(unlockedAchievementsProvider.notifier).evaluate();
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resultado eliminado'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Eliminar resultado',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  InputDecoration _scoreDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;
  final Team home;
  final Team away;
  final VoidCallback onTap;

  const _GameCard({
    required this.game,
    required this.home,
    required this.away,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = game.isCompleted;
    final homePrimary = parseHexColor(home.primaryColor);
    final awayPrimary = parseHexColor(away.primaryColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      _formatDate(game.scheduledAt),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.35),
                      ),
                    ),
                    const Spacer(),
                    if (completed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'FINAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.greenAccent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Programado',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _teamLine(home, homePrimary, game.result?.homeScore, true),
                const SizedBox(height: 10),
                _teamLine(away, awayPrimary, game.result?.awayScore, false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _teamLine(Team team, Color color, int? score, bool isHome) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            team.logoAsset,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.sports_football, size: 16, color: color),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                isHome ? 'Local' : 'Visitante',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
        Text(
          score?.toString() ?? '—',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: score != null ? Colors.white : Colors.white24,
          ),
        ),
      ],
    );
  }
}

class _TeamScoreRow extends StatelessWidget {
  final Team team;
  final int? score;
  final bool isHome;

  const _TeamScoreRow({
    required this.team,
    required this.score,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    final primary = parseHexColor(team.primaryColor);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            team.logoAsset,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.sports_football, size: 18, color: primary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            team.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          score?.toString() ?? '—',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: score != null ? Colors.white : Colors.white38,
          ),
        ),
      ],
    );
  }
}
