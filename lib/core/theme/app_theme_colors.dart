import 'package:flutter/material.dart';

abstract class AppThemeColors {
  AppThemeColors._();

  // ─── Azetta core palette ──────────────────────────────────────────────────
  // Terracotta / clay red (primary), deep indigo (secondary), sand / ochre
  // (accent), warm charcoal (text), warm off-white (background).
  static const Color primary = Color(0xFFB04A2C); // clay / terracotta
  static const Color primaryLight = Color(0xFFC9694A);
  static const Color primarySurface = Color(0xFFF3E1D6); // pale clay wash
  static const Color accent = Color(0xFFD2A24A); // sand / ochre
  static const Color accentDark = Color(0xFFB07F2C);
  static const Color background = Color(0xFFF5EEE0); // warm off-white
  static const Color surface = Color(0xFFFBF6EC); // warm card white
  static const Color surfaceVariant = Color(0xFFEFE4D2); // woven sand
  static const Color textPrimary = Color(0xFF2B2018); // warm charcoal
  static const Color textSecondary = Color(0xFF6F5F52);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFA3927F);
  static const Color success = Color(0xFF5E7444); // woven green
  static const Color error = Color(0xFFB23A2E);
  static const Color divider = Color(0xFFDDCEBB);

  // Deep indigo — secondary cultural accent.
  static const Color indigo = Color(0xFF273456);
  static const Color indigoLight = Color(0xFF3A4A73);

  static const Color mapPointTeal = Color(0xFF4E9A8F);
  static const Color mapPointGreen = success;
  static const Color mapPointOrange = Color(0xFFD2792E);
  static const Color mapPointYellow = accent;

  // Chat bubbles — distinct warm tones.
  static const Color chatBubbleAI = Color(0xFFF6EDDC); // warm sand card
  static const Color chatBubbleUser = primary; // clay

  // Fiabilité chip tones.
  static const Color fiabiliteDocumentee = success; // woven green
  static const Color fiabilitePartielle = accentDark; // ochre
  static const Color fiabiliteAVerifier = Color(0xFFA8442B); // rust clay

  // Geometric "talwt" motif tint.
  static const Color motif = indigo;

  // legacy aliases
  static const Color primaryAccent = primary;
  static const Color secondaryAccent = accent;
  static const Color card = surface;
  static const Color primaryText = textPrimary;
  static const Color secondaryText = textSecondary;
  static const Color hintText = textMuted;
  static const Color inputBorder = divider;
  static const Color inputFill = surfaceVariant;
  static const Color button = primary;
  static const Color splashBackground = background;
  static const Color gold = accent;
  static const Color subtitleText = textSecondary;
  static const Color dividerText = divider;
  static const Color onboardingBackground = background;
  static const Color selected = primaryLight;
  static const Color border = divider;
  static const Color formCard = surface;
  static const Color warning = accentDark;
  static const Color info = indigo;
  static const Color activeEventDot = success;
  static const Color readingBackground = background;
  static const Color highlight = accent;
  static const Color bookmark = accentDark;
  static const Color google = Color(0xFFDB4437);
  static const Color apple = Color(0xFF000000);
  static const Color overlay = Color(0x66000000);
  static const Color shimmer = Color(0xFFEDE3D2);
  static const Color photoSlot = surfaceVariant;
  static const Color tipsBackground = primarySurface;
  static const Color enrollDisabled = textMuted;
  static const Color tabUnselectedText = textSecondary;
  static const Color tabDivider = divider;
  static const Color gradientOverlay = overlay;
  static const Color activeCardBackground = primarySurface;
  static const Color activeCardBorder = primaryLight;
  static const Color archivedCardBackground = surfaceVariant;
  static const Color archivedCardBorder = divider;
  static const Color cardDateText = textSecondary;
  static const Color archivedTitle = textPrimary;
  static const Color archivedDate = textSecondary;
  static const double activeCardBackgroundOpacity = 1;
  static const double archivedCardBackgroundOpacity = 1;
  static const double archivedCardBorderOpacity = 1;
}
