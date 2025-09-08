import 'package:flutter/material.dart';

/// Classe utilitaire pour les couleurs sémantiques de l'application.
/// Toutes les couleurs sont dérivées du ColorScheme pour respecter les thèmes.
class SemanticColors {
  // Private constructor pour empêcher l'instantiation
  SemanticColors._();

  /// Couleur pour le niveau bas de la jauge (0-24%)
  /// Utilise une teinte verte douce dérivée du success/tertiary
  static Color loveLevelLow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Vert doux dérivé de la palette
    return isDark
        ? Color.alphaBlend(
            scheme.primary.withOpacity(0.2),
            const Color(0xFF4CAF50),
          )
        : Color.alphaBlend(
            scheme.primary.withOpacity(0.1),
            const Color(0xFF66BB6A),
          );
  }

  /// Couleur pour le niveau moyen de la jauge (25-74%)
  /// Utilise une teinte orange/amber warning-like
  static Color loveLevelMid(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Orange/amber dérivé
    return isDark
        ? Color.alphaBlend(
            scheme.primary.withOpacity(0.3),
            const Color(0xFFFF9800),
          )
        : Color.alphaBlend(
            scheme.primary.withOpacity(0.2),
            const Color(0xFFFFA726),
          );
  }

  /// Couleur pour le niveau haut de la jauge (75-100%)
  /// Utilise un mix corail/or basé sur primary/tertiary
  static Color loveLevelHigh(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Corail/or dérivé du primary avec teinte dorée
    return isDark
        ? Color.alphaBlend(scheme.secondary, scheme.primary.withOpacity(0.9))
        : Color.alphaBlend(
            const Color(0xFFFFD700).withOpacity(0.3),
            scheme.primary,
          );
  }

  /// Couleur neutre pour texte sur surface
  /// onSurface avec opacité réduite pour hiérarchie visuelle
  static Color neutralOnSurface(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
  }

  /// Couleur pour les bordures
  /// Utilise outline ou onSurface avec opacité faible
  static Color border(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? scheme.onSurface.withOpacity(0.2)
        : scheme.outline.withOpacity(0.3);
  }

  /// Couleur de succès générique
  static Color success(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF4CAF50) : const Color(0xFF66BB6A);
  }

  /// Couleur d'avertissement générique
  static Color warning(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFFFF9800) : const Color(0xFFFFA726);
  }

  /// Couleur d'erreur douce (pour les avertissements de rupture)
  static Color errorSoft(BuildContext context) {
    return Theme.of(context).colorScheme.error.withOpacity(0.8);
  }

  /// Couleur pour l'effet glow des jauges
  static Color glowEffect(BuildContext context, Color baseColor) {
    return baseColor.withOpacity(0.4);
  }
}
