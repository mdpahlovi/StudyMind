import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/theme/colors.dart';

class AppTheme {
  final String mode;
  final ColorPalette colorPalette;

  AppTheme({required this.mode}) : colorPalette = AppColors().getPalette(mode);

  ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: mode == 'dark' ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme(
      brightness: mode == 'dark' ? Brightness.dark : Brightness.light,
      primary: colorPalette.primary,
      onPrimary: colorPalette.white,
      primaryContainer: colorPalette.primaryShades[50],
      onPrimaryContainer: colorPalette.primaryShades[900],
      secondary: colorPalette.secondary,
      onSecondary: colorPalette.white,
      secondaryContainer: colorPalette.secondaryShades[50],
      onSecondaryContainer: colorPalette.secondaryShades[900],
      tertiary: colorPalette.tertiary,
      onTertiary: colorPalette.white,
      tertiaryContainer: colorPalette.tertiaryShades[50],
      onTertiaryContainer: colorPalette.tertiaryShades[900],
      error: colorPalette.error,
      onError: colorPalette.white,
      surface: colorPalette.surface,
      onSurface: colorPalette.content,
      outline: colorPalette.border,
    ),
    textTheme: TextTheme(
      // Display Text
      displayLarge: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: colorPalette.content,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: colorPalette.content,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorPalette.content,
        letterSpacing: -0.25,
        height: 1.3,
      ),

      // Headline Text
      headlineLarge: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorPalette.content,
        height: 1.4,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),

      // Title Text
      titleLarge: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorPalette.content,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),

      // Body Text
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorPalette.content,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorPalette.content,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorPalette.contentDim,
        height: 1.5,
      ),

      // Label Text
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorPalette.content,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: colorPalette.contentDim,
        height: 1.4,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(indicatorColor: colorPalette.primary),
    appBarTheme: AppBarTheme(
      color: colorPalette.surface,
      foregroundColor: colorPalette.content,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: colorPalette.content),
      titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: colorPalette.content),
    ),
    scaffoldBackgroundColor: colorPalette.background,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorPalette.primary,
      splashColor: colorPalette.primaryShades[500],
      shape: const CircleBorder(),
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      shadowColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: colorPalette.surface,
      filled: true,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPalette.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPalette.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPalette.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPalette.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorPalette.error, width: 2),
      ),
      labelStyle: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorPalette.contentDim,
      ),
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: colorPalette.contentDim),
      helperStyle: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorPalette.contentDim,
      ),
      errorStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400, color: colorPalette.error),
      prefixIconColor: colorPalette.contentDim,
      suffixIconColor: colorPalette.contentDim,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPalette.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
    dividerTheme: DividerThemeData(space: 0, thickness: 1, color: colorPalette.border),
  );
}
