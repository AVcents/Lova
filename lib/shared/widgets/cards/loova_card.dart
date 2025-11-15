// lib/shared/widgets/cards/loova_card.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Widget de card standard LOOVA
///
/// Carte réutilisable avec deux variantes :
/// - Standard : surface blanche/anthracite avec border subtile
/// - Gradient : dégradé primaire pour mise en avant (hero cards)
///
/// Usage :
/// ```dart
/// // Card standard
/// LoovaCard(
///   child: Text('Contenu'),
/// )
///
/// // Card gradient (hero)
/// LoovaCard(
///   withGradient: true,
///   child: Text('Contenu important'),
/// )
///
/// // Card avec padding custom
/// LoovaCard(
///   padding: EdgeInsets.all(context.spacing.xl),
///   child: Text('Contenu'),
/// )
/// ```
class LoovaCard extends StatelessWidget {
  /// Contenu de la card
  final Widget child;

  /// Padding personnalisé. Si null, utilise cardPaddingMd (20px)
  final EdgeInsets? padding;

  /// Si true, applique un gradient primaire au lieu d'une couleur unie
  final bool withGradient;

  /// Radius personnalisé. Si null, utilise radii.lg (20px)
  final double? borderRadius;

  /// Couleur de la bordure. Si null, utilise outline avec opacité 0.2
  final Color? borderColor;

  /// Épaisseur de la bordure
  final double borderWidth;

  const LoovaCard({
    super.key,
    required this.child,
    this.padding,
    this.withGradient = false,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? context.spacing.cardPaddingMd,
      decoration: BoxDecoration(
        // Couleur ou gradient selon la variante
        color: withGradient ? null : colorScheme.surface,
        gradient: withGradient
            ? LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.3),
            colorScheme.secondaryContainer.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        borderRadius: BorderRadius.circular(
          borderRadius ?? context.radii.lg,
        ),
        border: Border.all(
          color: borderColor ?? colorScheme.outline.withOpacity(0.2),
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}