
// utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Dark Blue)
  static const Color primary = Color(0xFF22288A);
  static const Color primaryDark = Color(0xFF1A1F6B);
  static const Color primaryLight = Color(0xFF3A40A8);

  // Secondary Colors (Red/Pink)
  static const Color secondary = Color(0xFFFF4F59);
  static const Color secondaryDark = Color(0xFFE5464F);
  static const Color secondaryLight = Color(0xFFFF6B73);

  // Accent Colors (Light Pink)
  static const Color accent = Color(0xFFFFCDCE);
  static const Color accentLight = Color(0xFFFFE0E1);
  static const Color accentDark = Color(0xFFFFB4B6);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Module Colors (Using your color scheme)
  static const Color pictureWordModule = Color(0xFFFF4F59);
  static const Color fillBlankModule = Color(0xFF22288A);
  static const Color multipleChoiceModule = Color(0xFFFFCDCE);
  static const Color grammarModule = Color(0xFF22288A);
  static const Color teacherModule = Color(0xFFFF4F59);
  static const Color missingLetterModule = Color(0xFFFFCDCE);
  static const Color voiceModule = Color(0xFFFF4F59);
  static const Color textReadingModule = Color(0xFF22288A);
  static const Color dialogModule = Color(0xFFFFCDCE);
  static const Color cardGameModule = Color(0xFFFF4F59);
  static const Color balloonGameModule = Color(0xFF22288A);
  static const Color basketballModule = Color(0xFFFFCDCE);
  static const Color chatModule = Color(0xFFFF4F59);
  static const Color sentenceFormationModule = Color(0xFF22288A);
  static const Color youtubeModule = Color(0xFFFF4F59);
  static const Color blackboardModule = Color(0xFF22288A);
  static const Color letterScrambleModule = Color(0xFFFFCDCE);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF424242);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderActive = Color(0xFF2196F3);
  static const Color borderError = Color(0xFFF44336);

  // Gradient Colors (Using your color scheme)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, secondary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, surface],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondary, secondaryDark],
  );
}
