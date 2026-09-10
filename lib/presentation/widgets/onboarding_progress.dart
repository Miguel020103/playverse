import 'package:flutter/material.dart';

/// Barra de progreso del onboarding.
/// step: 1 = deporte, 2 = equipo principal, 3 = segundo equipo
class OnboardingProgress extends StatelessWidget {
  final int step;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.step,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    final progress = step / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Paso $step de $totalSteps',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}
