import 'package:flutter/material.dart';

class ColorPalette {
  final Color primary;
  final Map<int, Color> primaryShades;
  final Color secondary;
  final Map<int, Color> secondaryShades;
  final Color tertiary;
  final Map<int, Color> tertiaryShades;

  final Color white;
  final Color black;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  final Color background;
  final Color surface;
  final Color content;
  final Color contentDim;
  final Color border;

  const ColorPalette({
    required this.primary,
    required this.primaryShades,
    required this.secondary,
    required this.secondaryShades,
    required this.tertiary,
    required this.tertiaryShades,
    required this.white,
    required this.black,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.background,
    required this.surface,
    required this.content,
    required this.contentDim,
    required this.border,
  });
}

class AppColors {
  static const light = ColorPalette(
    // Primary color (Electric Blue)
    primary: Color(0xFF2563EB),
    primaryShades: {
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA),
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB), // Main primary color
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    },

    // Secondary color (Vibrant Purple)
    secondary: Color(0xFF7C3AED),
    secondaryShades: {
      50: Color(0xFFF5F3FF),
      100: Color(0xFFEDE9FE),
      200: Color(0xFFDDD6FE),
      300: Color(0xFFC4B5FD),
      400: Color(0xFFA78BFA),
      500: Color(0xFF8B5CF6),
      600: Color(0xFF7C3AED), // Main secondary color
      700: Color(0xFF6D28D9),
      800: Color(0xFF5B21B6),
      900: Color(0xFF4C1D95),
    },

    // Tertiary color (Hot Pink/Magenta)
    tertiary: Color(0xFFEC4899),
    tertiaryShades: {
      50: Color(0xFFFDF2F8),
      100: Color(0xFFFCE7F3),
      200: Color(0xFFFBCFE8),
      300: Color(0xFFF9A8D4),
      400: Color(0xFFF472B6),
      500: Color(0xFFEC4899), // Main tertiary color
      600: Color(0xFFDB2777),
      700: Color(0xFFBE185D),
      800: Color(0xFF9D174D),
      900: Color(0xFF831843),
    },

    // Utility colors
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    success: Color(0xFF10B981), // Emerald green
    warning: Color(0xFFF59E0B), // Amber
    error: Color(0xFFEF4444), // Red
    info: Color(0xFF06B6D4), // Cyan
    // UI colors
    background: Color(0xFFFFFFFF), // White background
    surface: Color(0xFFF5F5F5), // Light gray surface
    content: Color(0xFF000000), // Black content text
    contentDim: Color(0xFF575757), // Grayish content text
    border: Color(0xFFE0E0E0), // Light gray border
  );

  static const dark = ColorPalette(
    // Primary color (Brighter Blue for dark mode)
    primary: Color(0xFF60A5FA),
    primaryShades: {
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA), // Main primary for dark mode
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB),
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    },

    // Secondary color (Brighter Purple for dark mode)
    secondary: Color(0xFFA78BFA),
    secondaryShades: {
      50: Color(0xFFF5F3FF),
      100: Color(0xFFEDE9FE),
      200: Color(0xFFDDD6FE),
      300: Color(0xFFC4B5FD),
      400: Color(0xFFA78BFA), // Main secondary for dark mode
      500: Color(0xFF8B5CF6),
      600: Color(0xFF7C3AED),
      700: Color(0xFF6D28D9),
      800: Color(0xFF5B21B6),
      900: Color(0xFF4C1D95),
    },

    // Tertiary color (Softer Pink for dark mode)
    tertiary: Color(0xFFF472B6),
    tertiaryShades: {
      50: Color(0xFFFDF2F8),
      100: Color(0xFFFCE7F3),
      200: Color(0xFFFBCFE8),
      300: Color(0xFFF9A8D4),
      400: Color(0xFFF472B6), // Main tertiary for dark mode
      500: Color(0xFFEC4899),
      600: Color(0xFFDB2777),
      700: Color(0xFFBE185D),
      800: Color(0xFF9D174D),
      900: Color(0xFF831843),
    },

    // Utility colors
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    success: Color(0xFF34D399), // Brighter emerald for dark mode
    warning: Color(0xFFFBBF24), // Brighter amber for dark mode
    error: Color(0xFFF87171), // Brighter red for dark mode
    info: Color(0xFF22D3EE), // Brighter cyan for dark mode
    // UI colors
    background: Color(0xFF0A0A0A), // Dark background
    surface: Color(0xFF101010), // Slightly lighter surface
    content: Color(0xFFFFFFFF), // White content text
    contentDim: Color(0xFFB4B4BE), // Slightly lighter content text
    border: Color(0xFF242424), // Dark gray border
  );

  ColorPalette get palette => dark;
  ColorPalette getPalette(String mode) => mode == "dark" ? dark : light;
}
