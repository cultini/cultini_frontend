import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme_colors.dart';

/// Typography tokens for the app.
///
/// Azetta type system: a warm characterful serif (Fraunces) for headings and
/// a clean humanist sans (Hanken Grotesk) for body / labels. Defined once here.
abstract class AppThemeTextStyles {
  AppThemeTextStyles._();

  static TextStyle get appBarTitleStyle => GoogleFonts.fraunces(
    color: AppThemeColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get buttonTextStyle => GoogleFonts.hankenGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get inputHintStyle =>
      GoogleFonts.hankenGrotesk(color: AppThemeColors.hintText, fontSize: 14);

  static TextStyle get inputLabelStyle => GoogleFonts.hankenGrotesk(
    color: AppThemeColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get splashLargeText => GoogleFonts.fraunces(
    color: AppThemeColors.primaryText,
    fontSize: 48,
    height: 1.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get splashMediumText => GoogleFonts.fraunces(
    color: AppThemeColors.subtitleText,
    fontSize: 18,
    height: 1.55,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get onboardingLargeText => GoogleFonts.fraunces(
    color: AppThemeColors.primaryText,
    fontSize: 36,
    fontStyle: FontStyle.normal,
  );

  static TextStyle get onboardingMediumText => GoogleFonts.hankenGrotesk(
    color: AppThemeColors.subtitleText,
    fontSize: 18,
    fontStyle: FontStyle.normal,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
    headlineLarge: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleLarge: GoogleFonts.fraunces(
      color: AppThemeColors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.secondaryText,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.secondaryText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.secondaryText,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.hankenGrotesk(
      color: AppThemeColors.hintText,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}
