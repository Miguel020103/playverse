import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/nfl/nfl_teams.dart';
import '../../domain/team/team.dart';
import '../user/user_provider.dart';

final allNflTeamsProvider = Provider<List<Team>>((ref) {
  return NflTeams.all;
});

final teamByIdProvider = Provider.family<Team?, String>((ref, id) {
  return NflTeams.byId(id);
});

final mainTeamProvider = Provider<Team?>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  if (prefs.mainTeamId == null) return null;
  return NflTeams.byId(prefs.mainTeamId!);
});

final secondTeamProvider = Provider<Team?>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  if (prefs.secondTeamId == null) return null;
  return NflTeams.byId(prefs.secondTeamId!);
});

final followedTeamsProvider = Provider<List<Team>>((ref) {
  final main = ref.watch(mainTeamProvider);
  final second = ref.watch(secondTeamProvider);
  final list = <Team>[];
  if (main != null) list.add(main);
  if (second != null) list.add(second);
  return list;
});
