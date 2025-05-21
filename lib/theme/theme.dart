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
      displayLarge: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: color.content, letterSpacing: -0.5, height: 1.2),
      displayMedium: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.bold, color: color.content, letterSpacing: -0.5, height: 1.2),
      displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: color.content, letterSpacing: -0.25, height: 1.3),

      // Headline Text
      headlineLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: color.content, height: 1.4),
      headlineMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      headlineSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: color.content, height: 1.4),

      // Title Text
      titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: color.content, height: 1.4),
      titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: color.content, height: 1.4),

      // Body Text
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: color.content, height: 1.5),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: color.content, height: 1.5),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: color.content, height: 1.5),

      // Label Text
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: color.content, height: 1.4),
      labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: color.content, height: 1.4),
    ),
    appBarTheme: AppBarTheme(
      color: color.surface,
      foregroundColor: color.content,
      centerTitle: true,
      iconTheme: IconThemeData(color: color.content),
      titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: color.content),
    ),
    scaffoldBackgroundColor: color.background,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color.primary,
      splashColor: color.primaryShades[500],
      shape: const CircleBorder(),
    ),
  );
}
