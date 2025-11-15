// lib/core/theme/loova_colors.dart

import 'package:flutter/material.dart';

/// Couleurs et gradients signature LOOVA
///
/// Définit le gradient caractéristique de LOOVA utilisé pour :
/// - Avatar de l'IA LOOVA
/// - Bulles de messages LOOVA
/// - Éléments de marque forte
///
/// Usage :
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     gradient: LoovaColors.gradient,
///   ),
/// )
/// ```
class LoovaColors {
  // Empêche l'instanciation
  LoovaColors._();

  /// Rose LOOVA - Couleur de départ du gradient
  static const Color gradientStart = Color(0xFFFF6FA5);

  /// Corail LOOVA - Couleur de fin du gradient
  static const Color gradientEnd = Color(0xFFFF5A6E);

  /// Gradient signature LOOVA
  ///
  /// Gradient linéaire de rose vers corail, avec direction top-left → bottom-right
  /// pour un effet dynamique et moderne.
  static LinearGradient get gradient => const LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Variante du gradient avec opacité
  ///
  /// Utile pour les backgrounds subtils ou overlays
  static LinearGradient gradientWithOpacity(double opacity) {
    return LinearGradient(
      colors: [
        gradientStart.withOpacity(opacity),
        gradientEnd.withOpacity(opacity),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Shadow color pour éléments avec gradient LOOVA
  ///
  /// Utilise la couleur de fin du gradient (corail) pour cohérence
  static Color shadowColor(double opacity) =>
      gradientEnd.withOpacity(opacity);
}