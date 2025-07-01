
// utils/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle get heading1 => GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get heading2 => GoogleFonts.roboto(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get heading3 => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get heading4 => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Special Text Styles
  static TextStyle get buttonText => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static TextStyle get appBarTitle => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static TextStyle get cardTitle => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get cardSubtitle => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static TextStyle get overline => GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // Learning specific styles
  static TextStyle get wordDisplay => GoogleFonts.roboto(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get translationDisplay => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static TextStyle get questionText => GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get optionText => GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.3,
  );
}
