import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LitColors {
  static const background = Color(0xFFE5F8F0); // Honeydew
  static const warmSurface = Color(0xFFECFFBE); // Tea Green
  static const softPeach = Color(0xFFBCA4F5); // Mauve
  static const softPeriwinkle = Color(0xFF81CFFF); // Sky Blue
  static const primaryPurple = Color(0xFF4A69CE); // Royal Blue
  static const text = Color(0xFF2E294E);
  static const mutedText = Color(0xFF6B6680);
  static const border = Color(0x1A2E294E);
}

ThemeData buildLitTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
    displaySmall: GoogleFonts.playfairDisplay(
      textStyle: base.textTheme.displaySmall?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: LitColors.text,
      ),
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      textStyle: base.textTheme.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: LitColors.text,
      ),
    ),
    titleLarge: base.textTheme.titleLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: LitColors.text,
    ),
    bodyMedium: base.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      height: 1.45,
      color: LitColors.text,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: LitColors.primaryPurple,
      secondary: LitColors.softPeriwinkle,
      tertiary: LitColors.softPeach,
      surface: Colors.white,
      background: LitColors.background,
      onPrimary: Colors.white,
      onSurface: LitColors.text,
      onBackground: LitColors.text,
    ),
    scaffoldBackgroundColor: LitColors.background,
    textTheme: textTheme,
    fontFamily: GoogleFonts.dmSans().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: LitColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: LitColors.text,
    ),
    dividerColor: LitColors.border,
  );
}
