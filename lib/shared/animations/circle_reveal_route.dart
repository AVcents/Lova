import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Clipper pour créer l'effet de révélation circulaire
class CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircleRevealClipper({
    required this.fraction,
    required this.center,
  });

  @override
  Path getClip(Size size) {
    // Calculer le rayon maximum pour couvrir tout l'écran
    final maxRadius = _calculateMaxRadius(size, center);
    final radius = fraction * maxRadius;

    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) {
    return oldClipper.fraction != fraction || oldClipper.center != center;
  }

  /// Calcule le rayon nécessaire pour couvrir tout l'écran depuis le centre
  double _calculateMaxRadius(Size size, Offset center) {
    final w = center.dx > size.width / 2 ? center.dx : size.width - center.dx;
    final h = center.dy > size.height / 2 ? center.dy : size.height - center.dy;
    return math.sqrt(w * w + h * h);
  }
}

/// Créer une route avec animation Circle Reveal
PageRouteBuilder<T> createCircleRevealRoute<T>({
  required Widget page,
  required Offset buttonCenter,
  required List<Color> gradientColors,
  Duration duration = const Duration(milliseconds: 450),
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Animation avec courbe
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, _) {
          return Stack(
            children: [
              // Fond avec gradient qui se propage
              if (curvedAnimation.value < 1.0)
                ClipPath(
                  clipper: CircleRevealClipper(
                    fraction: curvedAnimation.value,
                    center: buttonCenter,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              // Page qui apparaît
              ClipPath(
                clipper: CircleRevealClipper(
                  fraction: curvedAnimation.value,
                  center: buttonCenter,
                ),
                child: child,
              ),
            ],
          );
        },
      );
    },
  );
}

/// Extension pour faciliter la navigation avec Circle Reveal
extension CircleRevealNavigation on BuildContext {
  /// Naviguer avec animation Circle Reveal
  Future<T?> pushWithCircleReveal<T>({
    required Widget page,
    required GlobalKey buttonKey,
    required List<Color> gradientColors,
  }) {
    // Récupérer la position du bouton
    final RenderBox? renderBox =
    buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      // Fallback : navigation normale si on ne trouve pas la position
      return Navigator.of(this).push(
        MaterialPageRoute(builder: (_) => page),
      );
    }

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final buttonCenter = Offset(
      buttonPosition.dx + buttonSize.width / 2,
      buttonPosition.dy + buttonSize.height / 2,
    );

    return Navigator.of(this).push(
      createCircleRevealRoute<T>(
        page: page,
        buttonCenter: buttonCenter,
        gradientColors: gradientColors,
      ),
    );
  }
}