import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/achievements/achievements_provider.dart';
import '../../../application/teams/teams_provider.dart';
import '../../../application/user/user_provider.dart';
import '../../../core/utils/color_utils.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);
    final main = ref.watch(mainTeamProvider);
    final second = ref.watch(secondTeamProvider);
    final isDark = prefs.themeMode != 'light';
    final progress = ref.watch(achievementProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
          children: [
            Text(
              'PLAYVERSE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.white.withOpacity(0.35),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Más',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),

            // ── Equipos ───────────────────────────────────
            _SectionTitle('Tus equipos'),
            const SizedBox(height: 10),
            _Card(
              child: Column(
                children: [
                  if (main != null)
                    _TeamLine(
                      name: main.name,
                      subtitle: 'Equipo principal',
                      logo: main.logoAsset,
                      color: parseHexColor(main.primaryColor),
                      onTap: () => context.push('/team/${main.id}'),
                    ),
                  if (main != null && second != null)
                    Divider(color: Colors.white.withOpacity(0.06), height: 1),
                  if (second != null)
                    _TeamLine(
                      name: second.name,
                      subtitle: 'Segundo equipo',
                      logo: second.logoAsset,
                      color: parseHexColor(second.primaryColor),
                      onTap: () => context.push('/team/${second.id}'),
                    ),
                  if (main == null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin equipos seleccionados',
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _ActionTile(
              icon: Icons.swap_horiz_rounded,
              title: 'Cambiar equipos',
              subtitle: 'Volver a elegir principal y segundo',
              onTap: () => _confirmResetTeams(context, ref),
            ),

            const SizedBox(height: 28),

            // ── Apariencia ────────────────────────────────
            _SectionTitle('Apariencia'),
            const SizedBox(height: 10),
            _Card(
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: const Text(
                  'Tema oscuro',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  isDark ? 'Activado' : 'Desactivado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
                value: isDark,
                activeColor: Colors.white,
                onChanged: (v) {
                  ref
                      .read(userPreferencesProvider.notifier)
                      .setThemeMode(v ? 'dark' : 'light');
                },
              ),
            ),

            const SizedBox(height: 28),

            // ── Progreso / próximos ───────────────────────
            _SectionTitle('Progreso'),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.emoji_events_rounded,
              title: 'Logros',
              subtitle: '${progress.unlocked} / ${progress.total} desbloqueados',
              onTap: () => context.push('/achievements'),
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.menu_book_rounded,
              title: 'Learn',
              subtitle: 'Reglas, glosario y datos de la NFL',
              locked: true,
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.stadium_rounded,
              title: 'MY ARENA',
              subtitle: 'Crea tus propias competiciones',
              locked: true,
            ),

            const SizedBox(height: 28),

            // ── App ───────────────────────────────────────
            _SectionTitle('App'),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.info_outline_rounded,
              title: 'Acerca de PLAYVERSE',
              subtitle: 'v1.1.0 · Foundation',
              onTap: () => _showAbout(context),
            ),
            const SizedBox(height: 10),
            _ActionTile(
              icon: Icons.refresh_rounded,
              title: 'Reiniciar onboarding',
              subtitle: 'Borra preferencias y vuelve al inicio',
              destructive: true,
              onTap: () => _confirmFullReset(context, ref),
            ),

            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.sports,
                        color: Colors.white24,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'PLAYVERSE',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.1.0 · NFL 2026',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your sport. Your teams. Your arena.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmResetTeams(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1D),
        title: const Text('Cambiar equipos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(
          'Se reiniciará la selección de equipos. Los resultados guardados se mantienen.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuar',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) {
      // cleared via reset
      // Use reset of onboarding path by clearing completion and teams via full prefs
      await ref.read(userPreferencesProvider.notifier).reset();
      if (context.mounted) context.go('/welcome');
    }
  }

  Future<void> _confirmFullReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1D),
        title: const Text('Reiniciar app',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: Text(
          'Se borrarán preferencias de usuario. Los resultados de partidos se mantienen.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reiniciar',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(userPreferencesProvider.notifier).reset();
      if (context.mounted) context.go('/welcome');
    }
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF141418),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: Colors.white12,
                    child: const Icon(Icons.sports, color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'PLAYVERSE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your sport. Your teams. Your arena.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Plataforma deportiva personalizable para seguir equipos, resultados, clasificaciones y logros.\n\nDeporte inicial: NFL 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Versión 1.1.0 · Foundation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: Colors.white.withOpacity(0.45),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _TeamLine extends StatelessWidget {
  final String name;
  final String subtitle;
  final String logo;
  final Color color;
  final VoidCallback onTap;

  const _TeamLine({
    required this.name,
    required this.subtitle,
    required this.logo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                logo,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.sports_football, color: color, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool locked;
  final bool destructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.locked = false,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Colors.redAccent : Colors.white;

    return Material(
      color: const Color(0xFF1A1A1D),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: locked ? 0.45 : 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                if (locked)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Pronto',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.orange,
                      ),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
