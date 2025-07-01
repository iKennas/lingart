// utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryBlue = Color(0xFF22288A);
  static const Color accentRed = Color(0xFFFF4F59);
  static const Color softPink = Color(0xFFFFCDCE);
  static const Color darkBlue = Color(0xFF1A1F6B);
  static const Color lightBlue = Color(0xFF3A42B5);
  static const Color vibrantRed = Color(0xFFFF3B47);
  static const Color paleRose = Color(0xFFFFF0F1);
  static const Color blushPink = Color(0xFFFFE4E6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color mediumGrey = Color(0xFF6B6B6B);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color borderGrey = Color(0xFFE0E0E0);

  // Additional colors for balloon_game_screen.dart
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color primaryNavy = Color(0xFF22288A); // Same as primaryBlue
  static const Color lightPink = Color(0xFFFFCDCE); // Same as softPink
  static const Color success = Color(0xFF4CAF50);
  static const Color accentCoral = Color(0xFFFF4F59); // Same as accentRed

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, lightBlue],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentRed, vibrantRed],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [paleRose, blushPink],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, lightGrey],
  );

  // Shadows
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get accentShadow => [
    BoxShadow(
      color: accentRed.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Additional shadows for balloon_game_screen.dart
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: black.withOpacity(0.10),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: black.withOpacity(0.15),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  static const double radiusCircular = 50.0;

  // Additional radius for balloon_game_screen.dart
  static const double radiusM = 16.0; // Same as radiusMedium
  static const double radiusL = 24.0; // Same as radiusLarge
  static const double radiusXXL = 40.0;

  // Text Styles
  static TextTheme get textTheme => GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      height: 1.2,
      color: darkGrey,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.3,
      color: darkGrey,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.3,
      color: darkGrey,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.3,
      color: darkGrey,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      height: 1.4,
      color: darkGrey,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: darkGrey,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: darkGrey,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: mediumGrey,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: mediumGrey,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: darkGrey,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: mediumGrey,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: mediumGrey,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      color: white,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: mediumGrey,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: mediumGrey,
    ),
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ).copyWith(
    overlayColor: MaterialStateProperty.all(white.withOpacity(0.1)),
    shadowColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.3)),
    elevation: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) return 2;
      if (states.contains(MaterialState.hovered)) return 8;
      return 4;
    }),
  );

  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentRed,
    foregroundColor: white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ).copyWith(
    overlayColor: MaterialStateProperty.all(white.withOpacity(0.1)),
    shadowColor: MaterialStateProperty.all(accentRed.withOpacity(0.3)),
    elevation: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) return 2;
      if (states.contains(MaterialState.hovered)) return 8;
      return 4;
    }),
  );

  // Theme Data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: accentRed,
      tertiary: softPink,
      surface: white,
      background: lightGrey,
      error: accentRed,
      onPrimary: white,
      onSecondary: white,
      onSurface: darkGrey,
      onBackground: darkGrey,
      onError: white,
    ),
    textTheme: textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkGrey,
      ),
      iconTheme: const IconThemeData(color: darkGrey),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: white,
      shadowColor: black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
      margin: const EdgeInsets.all(spacing8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: accentRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing20,
        vertical: spacing16,
      ),
      hintStyle: GoogleFonts.inter(
        color: mediumGrey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: mediumGrey,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: borderGrey,
      thickness: 1,
      space: 1,
    ),
  );
}