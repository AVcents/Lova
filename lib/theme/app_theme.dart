import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: AppColors.text,
      onBackground: AppColors.text,
      onSurface: AppColors.text,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTypography.textTheme,
    fontFamily: AppTypography.fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: AppTypography.fontFamily,
      ),
    ),
  );
}