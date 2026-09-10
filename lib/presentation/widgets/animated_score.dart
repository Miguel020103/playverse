import 'package:flutter/material.dart';

/// Score que anima el cambio de valor.
class AnimatedScore extends StatelessWidget {
  final int? score;
  final TextStyle? style;

  const AnimatedScore({
    super.key,
    required this.score,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        score?.toString() ?? '—',
        key: ValueKey(score),
        style: style ??
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: score != null ? Colors.white : Colors.white24,
            ),
      ),
    );
  }
}