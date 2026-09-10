import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/standings_calculator.dart';
import '../../domain/standings/standing.dart';
import '../games/games_provider.dart';
import '../teams/teams_provider.dart';

final standingsProvider = Provider<List<Standing>>((ref) {
  final games = ref.watch(gamesLiveProvider);
  return StandingsCalculator.calculate(games);
});

final divisionStandingsProvider =
    Provider.family<List<Standing>, String>((ref, divisionId) {
  final all = ref.watch(standingsProvider);
  final teams = ref.watch(allNflTeamsProvider);
  final ids = teams
      .where((t) => t.divisionId == divisionId)
      .map((t) => t.id)
      .toSet();
  final list = all.where((s) => ids.contains(s.teamId)).toList()
    ..sort((a, b) => a.rank.compareTo(b.rank));
  return list;
});

final conferenceStandingsProvider =
    Provider.family<List<Standing>, String>((ref, conferenceId) {
  final games = ref.watch(gamesLiveProvider);
  return StandingsCalculator.calculateConference(games, conferenceId);
});

final teamStandingProvider = Provider.family<Standing?, String>((ref, teamId) {
  final all = ref.watch(standingsProvider);
  try {
    return all.firstWhere((s) => s.teamId == teamId);
  } catch (_) {
    return null;
  }
});

/// Wild-card style ranking: top non-division-winners by conference.
final wildCardOrderProvider =
    Provider.family<List<Standing>, String>((ref, conferenceId) {
  final conf = ref.watch(conferenceStandingsProvider(conferenceId));
  final divisionWinners = <String>{};

  // Approximate division winners = rank 1 of each division
  final teams = ref.watch(allNflTeamsProvider);
  final divisions = teams
      .where((t) => t.conferenceId == conferenceId)
      .map((t) => t.divisionId)
      .toSet();

  for (final div in divisions) {
    final divStandings = ref.watch(divisionStandingsProvider(div));
    if (divStandings.isNotEmpty) {
      divisionWinners.add(divStandings.first.teamId);
    }
  }

  final wildCards = conf
      .where((s) => !divisionWinners.contains(s.teamId))
      .toList()
    ..sort((a, b) {
      final cmp = b.winPercentage.compareTo(a.winPercentage);
      if (cmp != 0) return cmp;
      return b.pointDifferential.compareTo(a.pointDifferential);
    });

  return wildCards;
});
