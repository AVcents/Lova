import 'package:flutter/material.dart';

import 'package:lova/theme/typography.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF3D86),
    // hot pink (CTA)
    scaffoldBackgroundColor: const Color(0xFFF7F2F5),
    // blush background
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF3D86),
      // CTA
      secondary: Color(0xFFFF6FA5),
      surface: Colors.white,
      // white cards
      error: Color(0xFFD32F2F),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF151515),
      onError: Colors.white,
    ),
    textTheme: AppTypography.textTheme,
    fontFamily: 'Georgia',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF151515),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF151515)),
      titleTextStyle: TextStyle(
        color: Color(0xFF151515),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF3D86),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF5A6E),
    // corail (CTA)
    scaffoldBackgroundColor: const Color(0xFF0D0F12),
    // fond charcoal
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF5A6E),
      // corail pour actions principales
      secondary: Color(0xFFFF7A90),
      surface: Color(0xFF14161A),
      // anthracite (cartes/barres)
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Color(0xFF0D0F12),
      onSurface: Colors.white,
      onError: Colors.black,
    ),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    fontFamily: 'Georgia',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D0F12),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF5A6E), // CTA corail
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
