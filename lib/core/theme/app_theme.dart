import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const canvas = Color(0xFF101415);
  static const surface = Color(0xFF191C1E);
  static const surfaceHigh = Color(0xFF1D2022);
  static const surfaceHighest = Color(0xFF323537);
  static const ink = Color(0xFFE0E3E5);
  static const mutedInk = Color(0xFFBBC9CF);
  static const faintInk = Color(0xFF859399);
  static const line = Color(0xFF3C494E);
  static const primary = Color(0xFFA4E6FF);
  static const primaryStrong = Color(0xFF00D1FF);
  static const teal = Color(0xFF4CD6FF);
  static const coral = Color(0xFFFF8A73);
  static const amber = Color(0xFFFFD166);
  static const violet = Color(0xFFADC7FF);
  static const blue = Color(0xFF4A8EFF);

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryStrong,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvas,
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: ink,
        displayColor: ink,
      ),
      dividerColor: line,
      cardTheme: CardThemeData(
        color: surfaceHigh.withValues(alpha: 0.78),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryStrong.withValues(alpha: 0.08),
        side: BorderSide(color: primaryStrong.withValues(alpha: 0.20)),
        labelStyle: const TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryStrong,
          foregroundColor: const Color(0xFF003543),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
