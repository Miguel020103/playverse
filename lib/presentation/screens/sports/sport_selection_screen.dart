import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/user/user_provider.dart';
import '../../../domain/sport/sport.dart';
import '../../widgets/onboarding_progress.dart';

class SportSelectionScreen extends ConsumerWidget {
  const SportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnboardingProgress(step: 1),
                  const SizedBox(height: 32),
                  const Text(
                    'Elige tu deporte',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NFL está listo. El resto llegará en próximas versiones.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: Colors.white.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                itemCount: kSports.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final sport = kSports[index];
                  return _SportCard(
                    sport: sport,
                    onTap: sport.available
                        ? () async {
                            await ref
                                .read(userPreferencesProvider.notifier)
                                .setSport(sport.id);
                            if (context.mounted) context.go('/select-team');
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  final Sport sport;
  final VoidCallback? onTap;

  const _SportCard({required this.sport, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Material(
      color: const Color(0xFF16161A),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: enabled
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.04),
            ),
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.4,
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    sport.type == SportType.americanFootball
                        ? Icons.sports_football
                        : sport.type == SportType.soccer
                            ? Icons.sports_soccer
                            : Icons.sports_basketball,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport.nameEs,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sport.subtitleEs,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!enabled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pronto',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.black),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
