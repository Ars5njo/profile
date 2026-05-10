import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF202124);
  static const mutedInk = Color(0xFF5F6368);
  static const canvas = Color(0xFFF8F9F6);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE1E4DC);
  static const teal = Color(0xFF0F766E);
  static const coral = Color(0xFFE85D45);
  static const amber = Color(0xFFD6922C);
  static const violet = Color(0xFF6D5DD3);
  static const blue = Color(0xFF2563EB);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvas,
      textTheme: Typography.blackMountainView.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      dividerColor: line,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: line),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: canvas,
        side: const BorderSide(color: line),
        labelStyle: const TextStyle(
          color: ink,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
