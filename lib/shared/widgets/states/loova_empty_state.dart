// lib/shared/widgets/states/loova_empty_state.dart

import 'package:flutter/material.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// Widget d'état vide LOOVA
///
/// Affiche un écran vide avec icône, titre, sous-titre et CTA optionnel.
/// Utilisé quand il n'y a pas de données à afficher.
///
/// Usage :
/// ```dart
/// // Empty state simple
/// LoovaEmptyState(
///   icon: Icons.inbox,
///   title: 'Aucun check-in',
///   subtitle: 'Commencez par faire votre premier check-in',
/// )
///
/// // Empty state avec CTA
/// LoovaEmptyState(
///   icon: Icons.favorite_border,
///   title: 'Aucune intention',
///   subtitle: 'Créez votre première intention pour commencer',
///   ctaLabel: 'Créer une intention',
///   onCtaPressed: () => context.pushNamed('createIntention'),
/// )
///
/// // Empty state avec icône custom size
/// LoovaEmptyState(
///   icon: Icons.search,
///   iconSize: 80,
///   title: 'Aucun résultat',
///   subtitle: 'Essayez avec d\'autres mots-clés',
/// )
/// ```
class LoovaEmptyState extends StatelessWidget {
  /// Icône à afficher
  final IconData icon;

  /// Titre principal
  final String title;

  /// Sous-titre descriptif
  final String subtitle;

  /// Label du bouton CTA (optionnel)
  final String? ctaLabel;

  /// Callback du bouton CTA (optionnel)
  final VoidCallback? onCtaPressed;

  /// Taille de l'icône (défaut: 64)
  final double iconSize;

  /// Icône du bouton CTA (défaut: Icons.add)
  final IconData? ctaIcon;

  const LoovaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCtaPressed,
    this.iconSize = 64,
    this.ctaIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: context.spacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône
            Icon(
              icon,
              size: iconSize,
              color: colorScheme.outline,
            ),

            SizedBox(height: context.spacing.md),

            // Titre
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.spacing.xs),

            // Sous-titre
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),

            // CTA optionnel
            if (ctaLabel != null && onCtaPressed != null) ...[
              SizedBox(height: context.spacing.xl),
              ElevatedButton.icon(
                onPressed: onCtaPressed,
                icon: Icon(ctaIcon),
                label: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}