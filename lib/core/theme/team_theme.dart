import 'package:flutter/material.dart';

/// Team colors are FIXED and never altered by AppTheme (light/dark).
class TeamTheme {
  final Color primary;
  final Color secondary;
  final Color? tertiary;
  final Color onPrimary;
  final Color onSecondary;

  const TeamTheme({
    required this.primary,
    required this.secondary,
    this.tertiary,
    required this.onPrimary,
    required this.onSecondary,
  });

  factory TeamTheme.fromHex({
    required String primaryHex,
    required String secondaryHex,
    String? tertiaryHex,
  }) {
    final primary = _parse(primaryHex);
    final secondary = _parse(secondaryHex);
    final tertiary = tertiaryHex != null ? _parse(tertiaryHex) : null;

    return TeamTheme(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      onPrimary: _onColor(primary),
      onSecondary: _onColor(secondary),
    );
  }

  static Color _parse(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.parse(cleaned.length == 6 ? 'FF$cleaned' : cleaned, radix: 16);
    return Color(value);
  }

  static Color _onColor(Color bg) {
    return bg.computeLuminance() > 0.45 ? Colors.black : Colors.white;
  }
}
