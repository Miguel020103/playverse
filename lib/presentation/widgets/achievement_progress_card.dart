import 'package:flutter/material.dart';

/// Tarjeta de logro con barra de progreso y animación al desbloquear.
class AchievementProgressCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final double progress; // 0.0 - 1.0
  final String? progressLabel; // ej: "3 / 5"

  const AchievementProgressCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.progress = 0,
    this.progressLabel,
  });

  @override
  State<AchievementProgressCard> createState() => _AchievementProgressCardState();
}

class _AchievementProgressCardState extends State<AchievementProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (widget.unlocked) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AchievementProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.unlocked && widget.unlocked) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.unlocked ? _scaleAnim : const AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.unlocked
              ? Colors.amber.withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.unlocked
                ? Colors.amber.withOpacity(0.4)
                : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.unlocked
                        ? Colors.amber.withOpacity(0.2)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.unlocked ? Colors.amber : Colors.white24,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: widget.unlocked ? Colors.white : Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(widget.unlocked ? 0.5 : 0.28),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.unlocked)
                  const Icon(Icons.check_circle_rounded, color: Colors.amber, size: 24)
                else if (widget.progressLabel != null)
                  Text(
                    widget.progressLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
              ],
            ),
            if (!widget.unlocked && widget.progress > 0) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: widget.progress.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation(
                    Colors.amber.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}