import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/color_utils.dart';
import '../teams/teams_provider.dart';
import '../user/user_provider.dart';

class TeamTheme {
  final Color primary;
  final Color secondary;
  final LinearGradient gradient;
  final Color accent;

  const TeamTheme({
    required this.primary,
    required this.secondary,
    required this.gradient,
    required this.accent,
  });

  static TeamTheme fallback() {
    return TeamTheme(
      primary: const Color(0xFF1A1A2E),
      secondary: const Color(0xFF16213E),
      gradient: const LinearGradient(
        colors: [Color(0xFF1A1A2E), Color(0xFF0A0A0C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accent: Colors.white,
    );
  }
}

/// Tema dinámico basado en el equipo principal del usuario.
final teamThemeProvider = Provider<TeamTheme>((ref) {
  final prefs = ref.watch(userPreferencesProvider);
  final teamId = prefs.mainTeamId;
  if (teamId == null) return TeamTheme.fallback();

  final team = ref.watch(teamByIdProvider(teamId));
  if (team == null) return TeamTheme.fallback();

  final primary = parseHexColor(team.primaryColor);
  final secondary = parseHexColor(team.secondaryColor ?? team.primaryColor);

  return TeamTheme(
    primary: primary,
    secondary: secondary,
    gradient: LinearGradient(
      colors: [
        primary.withOpacity(0.7),
        const Color(0xFF0A0A0C),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accent: primary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
  );
});