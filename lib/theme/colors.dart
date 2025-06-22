import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorPalette {
  final Color primary;
  final Map<int, Color> primaryShades;
  final Color secondary;
  final Map<int, Color> secondaryShades;
  final Color tertiary;
  final Map<int, Color> tertiaryShades;
  final Color accent;
  final Map<int, Color> accentShades;

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
    required this.accent,
    required this.accentShades,
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
    // Primary color
    primary: Color(0xFF7D9B5F),
    primaryShades: {
      50: Color(0xFFF6F8F3),
      100: Color(0xFFEBF0E3),
      200: Color(0xFFD6E1C7),
      300: Color(0xFFB8CA9F),
      400: Color(0xFF9BB377),
      500: Color(0xFF7D9B5F), // Main primary color
      600: Color(0xFF6B8350),
      700: Color(0xFF596B42),
      800: Color(0xFF475436),
      900: Color(0xFF3A442C),
    },

    // Secondary color
    secondary: Color(0xFFA8C686),
    secondaryShades: {
      50: Color(0xFFF8FAF5),
      100: Color(0xFFF0F4E9),
      200: Color(0xFFE1E9D3),
      300: Color(0xFFCDD8B8),
      400: Color(0xFFB8CA9F),
      500: Color(0xFFA8C686), // Main secondary color
      600: Color(0xFF8FA872),
      700: Color(0xFF76895E),
      800: Color(0xFF5E6B4C),
      900: Color(0xFF4C553C),
    },

    // Tertiary color
    tertiary: Color(0xFFE6C79C),
    tertiaryShades: {
      50: Color(0xFFFDF9F4),
      100: Color(0xFFFAF2E7),
      200: Color(0xFFF4E4CE),
      300: Color(0xFFEDD5B5),
      400: Color(0xFFE6C79C), // Main tertiary color
      500: Color(0xFFDFB883),
      600: Color(0xFFD8A96A),
      700: Color(0xFFBF9456),
      800: Color(0xFF9C7844),
      900: Color(0xFF7A5C35),
    },

    // Accent color
    accent: Color(0xFFF5F5DC),
    accentShades: {
      50: Color(0xFFFFFFFE),
      100: Color(0xFFFEFEF8),
      200: Color(0xFFFDFDF0),
      300: Color(0xFFF9F9E8),
      400: Color(0xFFF7F7E2),
      500: Color(0xFFF5F5DC), // Main accent color
      600: Color(0xFFEAEAC4),
      700: Color(0xFFDFDFAC),
      800: Color(0xFFD4D494),
      900: Color(0xFFC9C97C),
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
    // Primary color
    primary: Color(0xFF9BB377),
    primaryShades: {
      50: Color(0xFF3A442C),
      100: Color(0xFF475436),
      200: Color(0xFF596B42),
      300: Color(0xFF6B8350),
      400: Color(0xFF7D9B5F),
      500: Color(0xFF9BB377), // Main primary for dark mode
      600: Color(0xFFB8CA9F),
      700: Color(0xFFD6E1C7),
      800: Color(0xFFEBF0E3),
      900: Color(0xFFF6F8F3),
    },

    // Secondary color
    secondary: Color(0xFFB8CA9F),
    secondaryShades: {
      50: Color(0xFF4C553C),
      100: Color(0xFF5E6B4C),
      200: Color(0xFF76895E),
      300: Color(0xFF8FA872),
      400: Color(0xFFA8C686),
      500: Color(0xFFB8CA9F), // Main secondary for dark mode
      600: Color(0xFFCDD8B8),
      700: Color(0xFFE1E9D3),
      800: Color(0xFFF0F4E9),
      900: Color(0xFFF8FAF5),
    },

    // Tertiary color
    tertiary: Color(0xFFDFB883),
    tertiaryShades: {
      50: Color(0xFF7A5C35),
      100: Color(0xFF9C7844),
      200: Color(0xFFBF9456),
      300: Color(0xFFD8A96A),
      400: Color(0xFFE6C79C),
      500: Color(0xFFDFB883), // Main tertiary for dark mode
      600: Color(0xFFEDD5B5),
      700: Color(0xFFF4E4CE),
      800: Color(0xFFFAF2E7),
      900: Color(0xFFFDF9F4),
    },

    // Accent color
    accent: Color(0xFFEAEAC4),
    accentShades: {
      50: Color(0xFFC9C97C),
      100: Color(0xFFD4D494),
      200: Color(0xFFDFDFAC),
      300: Color(0xFFEAEAC4),
      400: Color(0xFFF5F5DC),
      500: Color(0xFFEAEAC4),
      600: Color(0xFFF7F7E2),
      700: Color(0xFFF9F9E8),
      800: Color(0xFFFDFDF0),
      900: Color(0xFFFFFFFE),
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

  ColorPalette get palette => Get.isDarkMode ? dark : light;
  ColorPalette getPalette(String mode) => mode == "dark" ? dark : light;
}
