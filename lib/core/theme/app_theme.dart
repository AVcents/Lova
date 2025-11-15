// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:lova/theme/typography.dart';
import 'package:lova/core/theme/theme_extensions.dart';

/// LOOVA Design System - App Theme
/// Version 1.0
///
/// Thème Material 3 complet avec design tokens et extensions personnalisées.
/// Supporte les modes clair et sombre avec accessibilité WCAG 2.2 AA.
class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // ───────────────────────────────────────────────────────────────────
        // COLOR SCHEME
        // ───────────────────────────────────────────────────────────────────
        colorScheme: const ColorScheme.light(
          // Brand colors
          primary: Color(0xFFFF3D86), // Hot pink CTA
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFE5EE),
          onPrimaryContainer: Color(0xFF151515),

          secondary: Color(0xFFFF6FA5), // Rose doux
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFFFF0F6),
          onSecondaryContainer: Color(0xFF151515),

          // Surfaces
          surface: Color(0xFFFFFFFF), // Cards blanches
          onSurface: Color(0xFF151515),
          surfaceContainerLowest: Color(0xFFFFFFFF),
          surfaceContainerLow: Color(0xFFFAF8F9),
          surfaceContainer: Color(0xFFFFFFFF), // Blush background
          surfaceContainerHigh: Color(0xFFF2EDF0),
          surfaceContainerHighest: Color(0xFFEDE8EB),

          // Semantic colors
          error: Color(0xFFD32F2F),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFEBEE),
          onErrorContainer: Color(0xFF5D1F1F),

          // Outline & dividers
          outline: Color(0x1F000000), // rgba(0,0,0,0.12)
          outlineVariant: Color(0x0A000000), // rgba(0,0,0,0.04)

          // Backgrounds
          background: Color(0xFFFFFFFF), // Blush
          onBackground: Color(0xFF151515),
        ),

        scaffoldBackgroundColor: const Color(0xFFFFFFFF),

        // ───────────────────────────────────────────────────────────────────
        // TYPOGRAPHY
        // ───────────────────────────────────────────────────────────────────
        textTheme: AppTypography.textTheme,
        fontFamily: 'Georgia',

        // ───────────────────────────────────────────────────────────────────
        // APP BAR
        // ───────────────────────────────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          foregroundColor: Color(0xFF151515),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color(0xFF151515),
            size: 24,
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFF151515),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
            letterSpacing: 0,
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // BUTTONS
        // ───────────────────────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3D86),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            shadowColor: Colors.transparent,
            minimumSize: const Size(0, 48), // Touch target minimum
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF3D86),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF3D86),
            side: const BorderSide(
              color: Color(0xFFFF3D86),
              width: 1,
            ),
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF3D86),
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: const Color(0xFF151515),
            minimumSize: const Size(48, 48), // Touch target
            iconSize: 24,
            padding: const EdgeInsets.all(12),
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // CARDS
        // ───────────────────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFFFF),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFF000000).withOpacity(0.08),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(0),
        ),

        // ───────────────────────────────────────────────────────────────────
        // INPUTS
        // ───────────────────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFF000000).withOpacity(0.12),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFF000000).withOpacity(0.12),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFFF3D86),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFD32F2F),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFD32F2F),
              width: 2,
            ),
          ),
          hintStyle: TextStyle(
            color: const Color(0xFF151515).withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF151515),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // CHIPS
        // ───────────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF7F2F5),
          selectedColor: const Color(0xFFFFE5EE),
          disabledColor: const Color(0xFF000000).withOpacity(0.12),
          labelStyle: const TextStyle(
            color: Color(0xFF151515),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: const Color(0xFF000000).withOpacity(0.12),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),

        // ───────────────────────────────────────────────────────────────────
        // DIALOGS
        // ───────────────────────────────────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titleTextStyle: const TextStyle(
            color: Color(0xFF151515),
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Georgia',
          ),
          contentTextStyle: const TextStyle(
            color: Color(0xFF151515),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Georgia',
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // SNACKBAR
        // ───────────────────────────────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF151515),
          contentTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // ───────────────────────────────────────────────────────────────────
        // BOTTOM SHEET
        // ───────────────────────────────────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          modalElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // DIVIDER
        // ───────────────────────────────────────────────────────────────────
        dividerTheme: DividerThemeData(
          color: const Color(0xFF000000).withOpacity(0.12),
          thickness: 1,
          space: 1,
        ),

        // ───────────────────────────────────────────────────────────────────
        // CUSTOM EXTENSIONS
        // ───────────────────────────────────────────────────────────────────
        extensions: const <ThemeExtension<dynamic>>[
          AppSpacing.light(),
          AppRadii.standard(),
          AppShadows.light(),
          AppDurations.standard(),
          AppMotion.standard(),
        ],
      );

  // ═══════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // ───────────────────────────────────────────────────────────────────
        // COLOR SCHEME
        // ───────────────────────────────────────────────────────────────────
        colorScheme: const ColorScheme.dark(
          // Brand colors
          primary: Color(0xFFFF5A6E), // Corail CTA
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF4D1F26),
          onPrimaryContainer: Color(0xFFFFFFFF),

          secondary: Color(0xFFFF7A90),
          onSecondary: Color(0xFF0D0F12),
          secondaryContainer: Color(0xFF3D1A23),
          onSecondaryContainer: Color(0xFFFFFFFF),

          // Surfaces
          surface: Color(0xFF14161A), // Anthracite cards
          onSurface: Color(0xFFFFFFFF),
          surfaceContainerLowest: Color(0xFF0D0F12),
          surfaceContainerLow: Color(0xFF14161A),
          surfaceContainer: Color(0xFF14161A),
          surfaceContainerHigh: Color(0xFF1A1D22),
          surfaceContainerHighest: Color(0xFF1F2328),

          // Semantic colors
          error: Color(0xFFCF6679),
          onError: Color(0xFF000000),
          errorContainer: Color(0xFF5D1F1F),
          onErrorContainer: Color(0xFFFFFFFF),

          // Outline & dividers
          outline: Color(0x1FFFFFFF), // rgba(255,255,255,0.12)
          outlineVariant: Color(0x14FFFFFF), // rgba(255,255,255,0.08)

          // Backgrounds
          background: Color(0xFF0D0F12), // Charcoal
          onBackground: Color(0xFFFFFFFF),
        ),

        scaffoldBackgroundColor: const Color(0xFF0D0F12),

        // ───────────────────────────────────────────────────────────────────
        // TYPOGRAPHY
        // ───────────────────────────────────────────────────────────────────
        textTheme: AppTypography.textTheme.apply(
          bodyColor: const Color(0xFFFFFFFF),
          displayColor: const Color(0xFFFFFFFF),
        ),
        fontFamily: 'Georgia',

        // ───────────────────────────────────────────────────────────────────
        // APP BAR
        // ───────────────────────────────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0F12),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color(0xFFFFFFFF),
            size: 24,
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
            letterSpacing: 0,
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // BUTTONS
        // ───────────────────────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5A6E),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            shadowColor: Colors.transparent,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFF5A6E),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF5A6E),
            side: const BorderSide(
              color: Color(0xFFFF5A6E),
              width: 1,
            ),
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF5A6E),
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
              fontFamily: 'Georgia',
            ),
          ),
        ),

        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: const Color(0xFFFFFFFF),
            minimumSize: const Size(48, 48),
            iconSize: 24,
            padding: const EdgeInsets.all(12),
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // CARDS
        // ───────────────────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          color: const Color(0xFF14161A),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: const Color(0xFFFFFFFF).withOpacity(0.12),
              width: 1,
            ),
          ),
          margin: const EdgeInsets.all(0),
        ),

        // ───────────────────────────────────────────────────────────────────
        // INPUTS
        // ───────────────────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF14161A),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFFFFFFFF).withOpacity(0.12),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFFFFFFFF).withOpacity(0.12),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFFF5A6E),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFCF6679),
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFCF6679),
              width: 2,
            ),
          ),
          hintStyle: TextStyle(
            color: const Color(0xFFFFFFFF).withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // CHIPS
        // ───────────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF14161A),
          selectedColor: const Color(0xFF4D1F26),
          disabledColor: const Color(0xFFFFFFFF).withOpacity(0.12),
          labelStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: const Color(0xFFFFFFFF).withOpacity(0.12),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),

        // ───────────────────────────────────────────────────────────────────
        // DIALOGS
        // ───────────────────────────────────────────────────────────────────
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF14161A),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titleTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Georgia',
          ),
          contentTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Georgia',
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // SNACKBAR
        // ───────────────────────────────────────────────────────────────────
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1F2328),
          contentTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // ───────────────────────────────────────────────────────────────────
        // BOTTOM SHEET
        // ───────────────────────────────────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF14161A),
          elevation: 0,
          modalElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
        ),

        // ───────────────────────────────────────────────────────────────────
        // DIVIDER
        // ───────────────────────────────────────────────────────────────────
        dividerTheme: DividerThemeData(
          color: const Color(0xFFFFFFFF).withOpacity(0.12),
          thickness: 1,
          space: 1,
        ),

        // ───────────────────────────────────────────────────────────────────
        // CUSTOM EXTENSIONS
        // ───────────────────────────────────────────────────────────────────
        extensions: const <ThemeExtension<dynamic>>[
          AppSpacing.light(),
          AppRadii.standard(),
          AppShadows.dark(),
          AppDurations.standard(),
          AppMotion.standard(),
        ],
      );
}
