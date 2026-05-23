import 'package:flutter/material.dart';

import 'app_theme_colors.dart';

/// Flat alias surface over [AppThemeColors] used throughout the widgets.
abstract class AppColors {
  AppColors._();

  static const Color primary = AppThemeColors.primary;
  static const Color primaryLight = AppThemeColors.primaryLight;
  static const Color accent = AppThemeColors.accent;
  static const Color accentDark = AppThemeColors.accentDark;
  static const Color background = AppThemeColors.background;
  static const Color surface = AppThemeColors.surface;
  static const Color surfaceVariant = AppThemeColors.surfaceVariant;
  static const Color primarySurface = AppThemeColors.primarySurface;
  static const Color textPrimary = AppThemeColors.textPrimary;
  static const Color textSecondary = AppThemeColors.textSecondary;
  static const Color textMuted = AppThemeColors.textMuted;
  static const Color textLight = AppThemeColors.textLight;
  static const Color white = Colors.white;
  static const Color error = AppThemeColors.error;
  static const Color success = AppThemeColors.success;
  static const Color divider = AppThemeColors.divider;

  static const Color chatBubbleAI = AppThemeColors.chatBubbleAI;
  static const Color chatBubbleUser = AppThemeColors.chatBubbleUser;

  // Deep indigo + geometric motif tint.
  static const Color indigo = AppThemeColors.indigo;
  static const Color indigoLight = AppThemeColors.indigoLight;
  static const Color motif = AppThemeColors.motif;

  // Fiabilité chip tones (documentee / partielle / a_verifier).
  static const Color fiabiliteDocumentee = AppThemeColors.fiabiliteDocumentee;
  static const Color fiabilitePartielle = AppThemeColors.fiabilitePartielle;
  static const Color fiabiliteAVerifier = AppThemeColors.fiabiliteAVerifier;

  static const Color mapPointTeal = AppThemeColors.mapPointTeal;
  static const Color mapPointGreen = AppThemeColors.mapPointGreen;
  static const Color mapPointOrange = AppThemeColors.mapPointOrange;
  static const Color mapPointYellow = AppThemeColors.mapPointYellow;

  // Accent stats (used by the map header badges).
  static const Color streakOrange = Color(0xFFFF9F43);
  static const Color xpYellow = Color(0xFFE8B84B);
  static const Color heartRed = Color(0xFFFF4B4B);
}
