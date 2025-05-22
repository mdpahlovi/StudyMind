import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/theme/colors.dart';

class AppTheme {
  final String mode;
  final ColorPalette color;

  AppTheme({required this.mode}) : color = AppColors().getPalette(mode);

  ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: mode == 'dark' ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme(
      brightness: mode == 'dark' ? Brightness.dark : Brightness.light,
      primary: color.primary,
      onPrimary: color.white,
      primaryContainer: color.primaryShades[50],
      onPrimaryContainer: color.primaryShades[900],
      secondary: color.secondary,
      onSecondary: color.white,
      secondaryContainer: color.secondaryShades[50],
      onSecondaryContainer: color.secondaryShades[900],
      tertiary: color.tertiary,
      onTertiary: color.white,
      tertiaryContainer: color.tertiaryShades[50],
      onTertiaryContainer: color.tertiaryShades[900],
      error: color.error,
      onError: color.white,
      surface: color.surface,
      onSurface: color.content,
      outline: color.border,
    ),
    textTheme: TextTheme(
      // Display Text
      displayLarge: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: color.content, letterSpacing: -0.5, height: 1.2),
      displayMedium: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.bold, color: color.content, letterSpacing: -0.5, height: 1.2),
      displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w600, color: color.content, letterSpacing: -0.25, height: 1.3),

      // Headline Text
      headlineLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: color.content, height: 1.4),
      headlineMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      headlineSmall: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: color.content, height: 1.4),

      // Title Text
      titleLarge: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600, color: color.content, height: 1.4),
      titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500, color: color.contentLight, height: 1.4),

      // Body Text
      bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.normal, color: color.content, height: 1.5),
      bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.normal, color: color.content, height: 1.5),
      bodySmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.normal, color: color.contentLight, height: 1.5),

      // Label Text
      labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      labelMedium: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: color.contentLight, height: 1.4),
      labelSmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.normal, color: color.contentLight, height: 1.4),
    ),
    appBarTheme: AppBarTheme(
      color: color.surface,
      foregroundColor: color.content,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: color.content),
      titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: color.content),
    ),
    scaffoldBackgroundColor: color.background,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color.primary,
      splashColor: color.primaryShades[500],
      shape: const CircleBorder(),
    ),
    cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
  );
}
