// lib/shared/widgets/animations/typing_dots_indicator.dart

import 'package:flutter/material.dart';

/// Indicateur de frappe avec 3 dots animés
///
/// Widget réutilisable affichant 3 points qui rebondissent
/// pour indiquer qu'une action est en cours (typing, loading, etc.)
///
/// Usage :
/// ```dart
/// TypingDotsIndicator(
///   color: Colors.white,
///   size: 8,
/// )
/// ```
class TypingDotsIndicator extends StatelessWidget {
  /// Couleur des dots
  final Color color;

  /// Taille des dots (diamètre)
  final double size;

  /// Espacement entre les dots
  final double spacing;

  /// Durée d'un cycle d'animation complet
  final Duration duration;

  const TypingDotsIndicator({
    super.key,
    this.color = Colors.white,
    this.size = 8,
    this.spacing = 6,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AnimatedDot(
          color: color,
          size: size,
          delay: Duration.zero,
          duration: duration,
        ),
        SizedBox(width: spacing),
        _AnimatedDot(
          color: color,
          size: size,
          delay: Duration(milliseconds: (duration.inMilliseconds * 0.25).round()),
          duration: duration,
        ),
        SizedBox(width: spacing),
        _AnimatedDot(
          color: color,
          size: size,
          delay: Duration(milliseconds: (duration.inMilliseconds * 0.5).round()),
          duration: duration,
        ),
      ],
    );
  }
}

/// Dot animé individuel
///
/// Effectue un mouvement de translation verticale (bounce)
/// avec un délai spécifique pour créer l'effet cascade.
class _AnimatedDot extends StatefulWidget {
  final Color color;
  final double size;
  final Duration delay;
  final Duration duration;

  const _AnimatedDot({
    required this.color,
    required this.size,
    required this.delay,
    required this.duration,
  });

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Controller qui loop infiniment
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    // Animation de translation verticale (0 → -8px)
    _animation = Tween<double>(
      begin: 0.0,
      end: -8.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Démarrer l'animation après le délai spécifié
    if (widget.delay > Duration.zero) {
      _controller.stop();
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}