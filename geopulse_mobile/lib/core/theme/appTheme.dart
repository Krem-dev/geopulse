import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTypography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      background: AppColorsLight.background,
      surface: AppColorsLight.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onBackground: AppColorsLight.primaryText,
      onSurface: AppColorsLight.primaryText,
    ),
    scaffoldBackgroundColor: AppColorsLight.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      centerTitle: false,
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColorsLight.primaryText),
      displayMedium: AppTypography.displayMedium.copyWith(color: AppColorsLight.primaryText),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColorsLight.primaryText),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColorsLight.primaryText),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColorsLight.primaryText),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColorsLight.primaryText),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColorsLight.primaryText),
      titleSmall: AppTypography.titleSmall.copyWith(color: AppColorsLight.primaryText),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColorsLight.primaryText),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColorsLight.primaryText),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColorsLight.secondaryText),
      labelLarge: AppTypography.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppTypography.labelMedium.copyWith(color: AppColorsLight.primaryText),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColorsLight.secondaryText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: AppTypography.labelMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLight.surfaceVariant,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColorsLight.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColorsLight.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColorsLight.tertiaryText),
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColorsLight.secondaryText),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsLight.surfaceVariant,
      selectedColor: AppColors.primary,
      labelStyle: AppTypography.labelMedium.copyWith(color: AppColorsLight.primaryText),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorsLight.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColorsLight.secondaryText,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondary,
      error: Color(0xFFFF6B6B),
      background: AppColorsDark.background,
      surface: AppColorsDark.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onBackground: AppColorsDark.primaryText,
      onSurface: AppColorsDark.primaryText,
    ),
    scaffoldBackgroundColor: AppColorsDark.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsDark.surface,
      foregroundColor: AppColorsDark.primaryText,
      elevation: 4,
      centerTitle: false,
      titleTextStyle: AppTypography.headlineMedium.copyWith(color: AppColorsDark.primaryText),
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: AppColorsDark.primaryText),
      displayMedium: AppTypography.displayMedium.copyWith(color: AppColorsDark.primaryText),
      headlineLarge: AppTypography.headlineLarge.copyWith(color: AppColorsDark.primaryText),
      headlineMedium: AppTypography.headlineMedium.copyWith(color: AppColorsDark.primaryText),
      headlineSmall: AppTypography.headlineSmall.copyWith(color: AppColorsDark.primaryText),
      titleLarge: AppTypography.titleLarge.copyWith(color: AppColorsDark.primaryText),
      titleMedium: AppTypography.titleMedium.copyWith(color: AppColorsDark.primaryText),
      titleSmall: AppTypography.titleSmall.copyWith(color: AppColorsDark.primaryText),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColorsDark.primaryText),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColorsDark.primaryText),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColorsDark.secondaryText),
      labelLarge: AppTypography.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppTypography.labelMedium.copyWith(color: AppColorsDark.primaryText),
      labelSmall: AppTypography.labelSmall.copyWith(color: AppColorsDark.secondaryText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
        textStyle: AppTypography.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: BorderSide(color: AppColors.primaryLight, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: AppTypography.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: AppTypography.labelMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.surfaceVariant,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColorsDark.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColorsDark.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColorsDark.tertiaryText),
      labelStyle: AppTypography.bodyMedium.copyWith(color: AppColorsDark.secondaryText),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColorsDark.surfaceVariant,
      selectedColor: AppColors.primaryLight,
      labelStyle: AppTypography.labelMedium.copyWith(color: AppColorsDark.primaryText),
      secondaryLabelStyle: AppTypography.labelMedium.copyWith(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColorsDark.surface,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColorsDark.secondaryText,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
