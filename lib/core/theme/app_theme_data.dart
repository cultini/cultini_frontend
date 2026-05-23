import 'package:flutter/material.dart';

import 'app_theme_colors.dart';
import 'app_theme_metrics.dart';
import 'app_theme_text_styles.dart';

/// ThemeData factory for the app.
abstract class AppThemeData {
  AppThemeData._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppThemeColors.primaryAccent,
      scaffoldBackgroundColor: AppThemeColors.background,
      cardColor: AppThemeColors.card,
      colorScheme: const ColorScheme.dark(
        primary: AppThemeColors.primaryAccent,
        secondary: AppThemeColors.secondaryAccent,
        surface: AppThemeColors.surface,
        error: AppThemeColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppThemeColors.primaryText,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppThemeColors.background,
        foregroundColor: AppThemeColors.primaryText,
        elevation: 0,
        titleTextStyle: AppThemeTextStyles.appBarTitleStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColors.button,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          ),
          textStyle: AppThemeTextStyles.buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppThemeColors.primaryText,
          side: const BorderSide(color: AppThemeColors.inputBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          ),
          backgroundColor: AppThemeColors.surface,
        ),
      ),
      textTheme: AppThemeTextStyles.textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: const BorderSide(color: AppThemeColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: const BorderSide(color: AppThemeColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          borderSide: const BorderSide(
            color: AppThemeColors.primaryAccent,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppThemeColors.inputFill,
        hintStyle: AppThemeTextStyles.inputHintStyle,
        labelStyle: AppThemeTextStyles.inputLabelStyle,
        prefixIconColor: AppThemeColors.hintText,
        suffixIconColor: AppThemeColors.hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppThemeMetrics.spacingMd,
          vertical: AppThemeMetrics.spacingMd,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppThemeColors.card,
        elevation: 4,
        shadowColor: const Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
          side: const BorderSide(color: AppThemeColors.inputBorder, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppThemeColors.inputBorder,
        thickness: 0.5,
      ),
      iconTheme: const IconThemeData(color: AppThemeColors.secondaryText),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppThemeColors.primaryAccent,
        linearTrackColor: AppThemeColors.inputBorder,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
