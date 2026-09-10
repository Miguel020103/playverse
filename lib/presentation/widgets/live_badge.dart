import 'package:flutter/material.dart';

/// Badge animado "EN VIVO"
class LiveBadge extends StatefulWidget {
  final bool compact;

  const LiveBadge({super.key, this.compact = false});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 6 : 8,
          vertical: widget.compact ? 2 : 3,
        ),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'EN VIVO',
              style: TextStyle(
                fontSize: widget.compact ? 9 : 10,
                fontWeight: FontWeight.w900,
                color: Colors.redAccent,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}