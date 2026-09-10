import 'package:flutter/material.dart';
import '../../domain/game/game.dart';

/// Badge visual: Oficial ESPN vs Manual
class SourceBadge extends StatelessWidget {
  final DataSourceType source;
  final bool compact;

  const SourceBadge({
    super.key,
    required this.source,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOfficial = source == DataSourceType.remote;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: isOfficial
            ? Colors.green.withOpacity(0.15)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: isOfficial
            ? Border.all(color: Colors.greenAccent.withOpacity(0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOfficial) ...[
            const Icon(Icons.verified, size: 11, color: Colors.greenAccent),
            const SizedBox(width: 4),
          ],
          Text(
            isOfficial ? 'OFICIAL' : 'MANUAL',
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: isOfficial ? Colors.greenAccent : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}