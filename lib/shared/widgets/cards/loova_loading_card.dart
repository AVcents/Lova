// lib/shared/widgets/cards/loova_loading_card.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Widget d'état de chargement pour les cards
///
/// Affiche un CircularProgressIndicator centré dans une card.
/// Utilisé pour indiquer le chargement de données.
///
/// Usage :
/// ```dart
/// // Loading par défaut (200px)
/// LoovaLoadingCard()
///
/// // Loading avec hauteur personnalisée
/// LoovaLoadingCard(height: 300)
///
/// // Loading avec message
/// LoovaLoadingCard(
///   message: 'Chargement des données...',
/// )
/// ```
class LoovaLoadingCard extends StatelessWidget {
  /// Hauteur de la card
  final double height;

  /// Message optionnel sous le spinner
  final String? message;

  /// Taille du CircularProgressIndicator
  final double? progressSize;

  const LoovaLoadingCard({
    super.key,
    this.height = 200,
    this.message,
    this.progressSize,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(context.radii.lg),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: progressSize ?? 40,
              height: progressSize ?? 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colorScheme.primary,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: context.spacing.md),
              Text(
                message!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}