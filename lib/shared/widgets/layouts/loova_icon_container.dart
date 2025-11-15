// lib/shared/widgets/layouts/loova_icon_container.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Container circulaire avec icône et background coloré
///
/// Utilisé pour afficher des icônes avec un fond coloré arrondi,
/// notamment dans les cards hero (streak, stats, etc.)
///
/// Usage :
/// ```dart
/// // Icon container standard (primary color)
/// LoovaIconContainer(
///   icon: Icons.local_fire_department,
/// )
///
/// // Icon container avec couleur custom
/// LoovaIconContainer(
///   icon: Icons.favorite,
///   color: Colors.red,
/// )
///
/// // Icon container avec taille custom
/// LoovaIconContainer(
///   icon: Icons.star,
///   size: 40,
///   padding: 16,
/// )
///
/// // Icon container non circulaire
/// LoovaIconContainer(
///   icon: Icons.check,
///   shape: BoxShape.rectangle,
///   borderRadius: 12,
/// )
/// ```
class LoovaIconContainer extends StatelessWidget {
  /// Icône à afficher
  final IconData icon;

  /// Taille de l'icône (défaut: 32)
  final double size;

  /// Couleur de l'icône et du background
  /// Si null, utilise la couleur primaire du thème
  final Color? color;

  /// Padding autour de l'icône (défaut: spacing.sm = 12px)
  final double? padding;

  /// Forme du container (défaut: circle)
  final BoxShape shape;

  /// Border radius si shape = BoxShape.rectangle
  final double? borderRadius;

  /// Opacité du background (défaut: 0.15)
  final double backgroundOpacity;

  const LoovaIconContainer({
    super.key,
    required this.icon,
    this.size = 32,
    this.color,
    this.padding,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundOpacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = color ?? colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(padding ?? context.spacing.sm),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(backgroundOpacity),
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius ?? context.radii.sm)
            : null,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size,
      ),
    );
  }
}