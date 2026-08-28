import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LitColors {
  // 🌘 Fantasy dark pero tierno (cute) palette ✨
  static const background = Color(0xFF02182B); // Deep mystical navy
  static const warmSurface = Color(0xFF3B3664); // Muted indigo night
  static const goldSparks = Color(0xFFFAB940); // Yellow sparks detail
  static const brightCyan = Color(0xFF09BBC8); // Bright cyan magic
  static const primaryBlue = Color(0xFF405FFA); // Vibrant enchanted blue
  static const text = Color(0xFFD9FCED); // Minty stardust white
  static const mutedText = Color(0xFF8AA6A3); // Muted emerald shadows
  static const border = Color(0x3309BBC8); // Translucent cyan glow

  // Aliases to support existing UI components
  static const primaryPurple = primaryBlue;
  static const softPeriwinkle = brightCyan;
  static const softPeach = goldSparks;
}

ThemeData buildLitTheme() {
  final base = ThemeData.dark(useMaterial3: true);
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
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: LitColors.primaryBlue,
      secondary: LitColors.brightCyan,
      tertiary: LitColors.goldSparks,
      surface: LitColors.warmSurface,
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