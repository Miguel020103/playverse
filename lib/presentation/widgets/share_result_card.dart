import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget listo para capturar y compartir (resultado o resumen).
/// Para compartir de verdad se recomienda usar el paquete `share_plus`
/// + `screenshot` o `RepaintBoundary`.
class ShareResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String scoreText;
  final String? footer;
  final Color accentColor;

  const ShareResultCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.scoreText,
    this.footer,
    this.accentColor = Colors.greenAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF121218),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PLAYVERSE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            scoreText,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: accentColor,
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 16),
            Text(
              footer!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Helper simple: copia texto al portapapeles (fallback de compartir).
Future<void> shareAsText(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copiado al portapapeles. ¡Pégalo en Stories!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Genera texto listo para compartir un resultado.
String buildShareResultText({
  required String homeName,
  required String awayName,
  required int homeScore,
  required int awayScore,
  required int week,
}) {
  return '🏈 Week $week\n'
      '$awayName $awayScore - $homeScore $homeName\n'
      'Registrado en PlayVerse';
}

/// Genera texto para el resumen semanal.
String buildShareWeekText({
  required int week,
  required int wins,
  required int losses,
  required int ties,
}) {
  return '📊 Así fue mi Week $week en PlayVerse\n'
      '✅ $wins victorias  ❌ $losses derrotas  🤝 $ties empates\n'
      '#PlayVerse #NFL';
}