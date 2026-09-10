import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/summary/weekly_summary_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../widgets/empty_state.dart';

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  final int initialWeek;

  const WeeklySummaryScreen({super.key, this.initialWeek = 1});

  @override
  ConsumerState<WeeklySummaryScreen> createState() => _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  late int _week;

  @override
  void initState() {
    super.initState();
    _week = widget.initialWeek;
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(weeklySummaryProvider(_week));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Resumen semanal',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // Selector de semana
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 18,
              itemBuilder: (_, i) {
                final w = i + 1;
                final selected = w == _week;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('W$w'),
                    selected: selected,
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.black : Colors.white70,
                      fontSize: 13,
                    ),
                    backgroundColor: Colors.white.withOpacity(0.06),
                    onSelected: (_) => setState(() => _week = w),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Título
          Text(
            'Así fue tu Week $_week',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            summary.completedGames == 0
                ? 'Aún no hay resultados registrados'
                : '${summary.completedGames} partidos finalizados',
            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Stats cards
          Row(
            children: [
              _StatCard(label: 'Victorias', value: '${summary.wins}', color: Colors.greenAccent),
              const SizedBox(width: 10),
              _StatCard(label: 'Derrotas', value: '${summary.losses}', color: Colors.redAccent),
              const SizedBox(width: 10),
              _StatCard(label: 'Empates', value: '${summary.ties}', color: Colors.orangeAccent),
            ],
          ),
          const SizedBox(height: 16),

          // Win rate
          if (summary.completedGames > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Porcentaje de victorias',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(summary.winRate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: summary.winRate,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 28),
          const Text(
            'Partidos de tus equipos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          if (summary.favoriteGames.isEmpty)
            const EmptyState(
              icon: Icons.sports_football_outlined,
              title: 'Sin partidos esta semana',
              subtitle: 'No hay partidos de tus equipos en esta semana.',
            )
          else
            ...summary.favoriteGames.map((g) {
              final home = ref.watch(teamByIdProvider(g.homeTeamId));
              final away = ref.watch(teamByIdProvider(g.awayTeamId));
              if (home == null || away == null) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
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
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      g.isCompleted
                          ? '${g.result!.awayScore} - ${g.result!.homeScore}'
                          : 'Pendiente',
                      style: TextStyle(
                        color: g.isCompleted ? Colors.white : Colors.white38,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}