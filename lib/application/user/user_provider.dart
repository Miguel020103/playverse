import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';
import '../../domain/user/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserPreferencesNotifier(repo);
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final UserRepository _repo;

  UserPreferencesNotifier(this._repo) : super(_repo.getPreferences());

  Future<void> setMainTeam(String teamId) async {
    state = state.copyWith(mainTeamId: teamId);
    await _repo.savePreferences(state);
  }

  Future<void> setSecondTeam(String? teamId) async {
    if (teamId == null) {
      state = state.copyWith(clearSecondTeam: true);
    } else {
      state = state.copyWith(secondTeamId: teamId);
    }
    await _repo.savePreferences(state);
  }

  Future<void> setSport(String sportId) async {
    state = state.copyWith(selectedSportId: sportId);
    await _repo.savePreferences(state);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingCompleted: true);
    await _repo.savePreferences(state);
  }

  Future<void> setThemeMode(String mode) async {
    state = state.copyWith(themeMode: mode);
    await _repo.savePreferences(state);
  }

  Future<void> setLocale(String locale) async {
    state = state.copyWith(locale: locale);
    await _repo.savePreferences(state);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = _repo.getPreferences();
  }
}
