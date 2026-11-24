import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Brand colors shared across light and dark themes.
abstract final class AppColors {
  static const brandDark = Color(0xFF005341);
  static const brandGreen = Color(0xFF43A047);
  static const headerGradient = [brandDark, brandGreen];

  static const lightScaffold = Color(0xFFF4F6F5);
  static const darkScaffold = Color(0xFF0D0F0E);
  static const darkSurface = Color(0xFF1A1F1C);
  static const darkCard = Color(0xFF242B27);
  static const darkDivider = Color(0xFF3A4540);
}

class AppThemes {
  static const _fontFamily = 'Inter';

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      brightness: Brightness.light,
      primary: AppColors.brandDark,
      onPrimary: Colors.white,
      secondary: AppColors.brandGreen,
      surface: Colors.white,
      onSurface: Color(0xFF1A1A1A),
    ),
    scaffoldBackgroundColor: AppColors.lightScaffold,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.brandDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerColor: Colors.black12,
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.brandGreen,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brandGreen,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
      bodyMedium: TextStyle(color: Color(0xFF333333)),
      titleMedium: TextStyle(
        color: Color(0xFF1A1A1A),
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: _fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      brightness: Brightness.dark,
      primary: AppColors.brandGreen,
      onPrimary: Colors.white,
      secondary: AppColors.brandDark,
      surface: AppColors.darkSurface,
      onSurface: Color(0xFFE8ECE9),
      surfaceContainerHighest: AppColors.darkCard,
    ),
    scaffoldBackgroundColor: AppColors.darkScaffold,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.brandDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: _fontFamily,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkCard,
      elevation: 2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
    dividerColor: AppColors.darkDivider,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.brandGreen,
      textColor: Color(0xFFE8ECE9),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkDivider),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brandGreen,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE8ECE9)),
      bodyMedium: TextStyle(color: Color(0xFFB8C0BC)),
      titleMedium: TextStyle(
        color: Color(0xFFE8ECE9),
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE8ECE9)),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.brandGreen,
    ),
  );
}