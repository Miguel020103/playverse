import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/user/user_provider.dart';
import '../../core/theme/app_theme.dart';
import '../navigation/app_router.dart';

class PlayVerseApp extends ConsumerWidget {
  const PlayVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final prefs = ref.watch(userPreferencesProvider);

    final themeMode = switch (prefs.themeMode) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark, // por defecto dark (estilo deportivo)
    };

    return MaterialApp.router(
      title: 'PLAYVERSE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
