import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/standings/standings_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../core/utils/color_utils.dart';
import '../../../domain/standings/standing.dart';

class DivisionsScreen extends ConsumerStatefulWidget {
  const DivisionsScreen({super.key});

  @override
  ConsumerState<DivisionsScreen> createState() => _DivisionsScreenState();
}

class _DivisionsScreenState extends ConsumerState<DivisionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NFL 2026',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: Colors.white.withOpacity(0.35),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Clasificación',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Standings actualizados con los resultados registrados.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              indicatorWeight: 2.5,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white38,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'AFC'),
                Tab(text: 'NFC'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _ConferenceView(conferenceId: 'afc'),
                  _ConferenceView(conferenceId: 'nfc'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConferenceView extends ConsumerWidget {
  final String conferenceId;

  const _ConferenceView({required this.conferenceId});

  static const divisions = {
    'afc': ['afc_east', 'afc_north', 'afc_south', 'afc_west'],
    'nfc': ['nfc_east', 'nfc_north', 'nfc_south', 'nfc_west'],
  };

  static const labels = {
    'afc_east': 'East',
    'afc_north': 'North',
    'afc_south': 'South',
    'afc_west': 'West',
    'nfc_east': 'East',
    'nfc_north': 'North',
    'nfc_south': 'South',
    'nfc_west': 'West',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divs = divisions[conferenceId]!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        for (final div in divs) ...[
          _DivisionBlock(
            title: labels[div]!,
            divisionId: div,
          ),
          const SizedBox(height: 20),
        ],
        // Wild Card section
        _WildCardBlock(conferenceId: conferenceId),
      ],
    );
  }
}

class _DivisionBlock extends ConsumerWidget {
  final String title;
  final String divisionId;

  const _DivisionBlock({required this.title, required this.divisionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standings = ref.watch(divisionStandingsProvider(divisionId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(width: 36),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Equipo',
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ),
                _h('W'),
                _h('L'),
                _h('T'),
                _h('PCT'),
                _h('DIFF'),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 16),
          for (final s in standings)
            _StandingRow(standing: s, showRank: true),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _h(String t) => SizedBox(
        width: 36,
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.white38),
        ),
      );
}

class _WildCardBlock extends ConsumerWidget {
  final String conferenceId;

  const _WildCardBlock({required this.conferenceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wild = ref.watch(wildCardOrderProvider(conferenceId));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 16, color: Colors.amber.withOpacity(0.8)),
                const SizedBox(width: 8),
                Text(
                  'WILD CARD ORDER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: Colors.amber.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const SizedBox(width: 36),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Equipo',
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ),
                _h('W'),
                _h('L'),
                _h('PCT'),
                _h('DIFF'),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 16),
          if (wild.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Registra resultados para ver el orden de wild card.',
                style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13),
              ),
            )
          else
            for (var i = 0; i < wild.length && i < 7; i++)
              _StandingRow(
                standing: wild[i].copyWith(rank: i + 1),
                showRank: true,
                compact: true,
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _h(String t) => SizedBox(
        width: 36,
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.white38),
        ),
      );
}

class _StandingRow extends ConsumerWidget {
  final Standing standing;
  final bool showRank;
  final bool compact;

  const _StandingRow({
    required this.standing,
    this.showRank = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamByIdProvider(standing.teamId));
    if (team == null) return const SizedBox.shrink();
    final primary = parseHexColor(team.primaryColor);

    return InkWell(
      onTap: () => context.push('/team/${team.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (showRank)
              SizedBox(
                width: 22,
                child: Text(
                  '${standing.rank}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: standing.rank == 1
                        ? Colors.amber
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              )
            else
              const SizedBox(width: 22),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                team.logoAsset,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.sports_football, size: 14, color: primary),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                team.abbreviation,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            _cell('${standing.wins}'),
            _cell('${standing.losses}'),
            if (!compact) _cell('${standing.ties}'),
            _cell(standing.winPercentage.toStringAsFixed(3).substring(1)),
            _cell(
              standing.pointDifferential >= 0
                  ? '+${standing.pointDifferential}'
                  : '${standing.pointDifferential}',
              color: standing.pointDifferential > 0
                  ? Colors.greenAccent
                  : standing.pointDifferential < 0
                      ? Colors.redAccent
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cell(String t, {Color? color}) => SizedBox(
        width: 36,
        child: Text(
          t,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color ?? Colors.white70,
          ),
        ),
      );
}
