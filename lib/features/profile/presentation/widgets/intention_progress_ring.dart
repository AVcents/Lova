// lib/features/profile/presentation/widgets/intention_progress_ring.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class IntentionProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;

  const IntentionProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;
    final percentage = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressRingPainter(
          progress: progress,
          strokeWidth: strokeWidth,
          color: effectiveColor,
          backgroundColor: colorScheme.outline.withOpacity(0.1),
        ),
        child: Center(
          child: Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2; // Start at top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}