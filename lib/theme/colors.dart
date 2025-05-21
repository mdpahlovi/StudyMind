import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/theme.dart';

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
    required this.border,
  });
}

class AppColors {
  final ThemeController themeController = Get.put(ThemeController());

  static const light = ColorPalette(
    // Primary color (Olive Green)
    primary: Color(0xFF606C38),
    primaryShades: {
      50: Color(0xFFF4F6ED),
      100: Color(0xFFE5E8D7),
      200: Color(0xFFCED5B3),
      300: Color(0xFFB3BE8F),
      400: Color(0xFF8FA06B),
      500: Color(0xFF778A4F),
      600: Color(0xFF606C38), // Your main primary color
      700: Color(0xFF505A30),
      800: Color(0xFF3F4725),
      900: Color(0xFF2E351C),
    },

    // Secondary color (Dark Green)
    secondary: Color(0xFF283618),
    secondaryShades: {
      50: Color(0xFFEAECE6),
      100: Color(0xFFD5D9CC),
      200: Color(0xFFAFB599),
      300: Color(0xFF879167),
      400: Color(0xFF5F6D41),
      500: Color(0xFF424D29),
      600: Color(0xFF283618), // Your main secondary color
      700: Color(0xFF212D14),
      800: Color(0xFF192210),
      900: Color(0xFF10180A),
    },

    // Tertiary color (Cream)
    tertiary: Color(0xFFFEFAE0),
    tertiaryShades: {
      50: Color(0xFFFFFFFB),
      100: Color(0xFFFFFEF7),
      200: Color(0xFFFFFDE8),
      300: Color(0xFFFEFCE7),
      400: Color(0xFFFEFBE4),
      500: Color(0xFFFEFAE0), // Your main tertiary color
      600: Color(0xFFE5E1CA),
      700: Color(0xFFCCC9B4),
      800: Color(0xFFB3B19E),
      900: Color(0xFF999788),
    },

    // Utility colors
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    success: Color(0xFF588157), // A complementary green for success
    warning: Color(0xFFDDA15E), // Warm earthy tone for warning
    error: Color(0xFFBC6C25), // Rusty orange for error
    info: Color(0xFF344E41), // Deep forest green for info
    // UI colors
    background: Color(0xFFFFFFFF), // White background
    surface: Color(0xFFF5F5F5), // Light gray surface
    content: Color(0xFF000000), // Black content text
    border: Color(0xFFE0E0E0), // Light gray border
  );

  static const dark = ColorPalette(
    // Primary color (Olive Green)
    primary: Color(0xFF8FA06B),
    primaryShades: {
      50: Color(0xFFF4F6ED),
      100: Color(0xFFE5E8D7),
      200: Color(0xFFCED5B3),
      300: Color(0xFFB3BE8F),
      400: Color(0xFF8FA06B), // Using this as primary in dark mode
      500: Color(0xFF778A4F),
      600: Color(0xFF606C38),
      700: Color(0xFF505A30),
      800: Color(0xFF3F4725),
      900: Color(0xFF2E351C),
    },

    // Secondary color (Dark Green)
    secondary: Color(0xFF424D29),
    secondaryShades: {
      50: Color(0xFFEAECE6),
      100: Color(0xFFD5D9CC),
      200: Color(0xFFAFB599),
      300: Color(0xFF879167),
      400: Color(0xFF5F6D41),
      500: Color(0xFF424D29), // Using this as secondary in dark mode
      600: Color(0xFF283618),
      700: Color(0xFF212D14),
      800: Color(0xFF192210),
      900: Color(0xFF10180A),
    },

    // Tertiary color (Cream)
    tertiary: Color(0xFFCCC9B4),
    tertiaryShades: {
      50: Color(0xFFFFFFFB),
      100: Color(0xFFFFFEF7),
      200: Color(0xFFFFFDE8),
      300: Color(0xFFFEFCE7),
      400: Color(0xFFFEFBE4),
      500: Color(0xFFFEFAE0),
      600: Color(0xFFE5E1CA),
      700: Color(0xFFCCC9B4), // Using this as tertiary in dark mode
      800: Color(0xFFB3B19E),
      900: Color(0xFF999788),
    },

    // Utility colors
    white: Color(0xFFFFFFFF),
    black: Color(0xFF000000),
    success: Color(0xFF80AB82), // Lighter green for success in dark mode
    warning: Color(0xFFE6C280), // Lighter warm tone for warning
    error: Color(0xFFDE9151), // Lighter orange for error
    info: Color(0xFF5B8266), // Lighter forest green for info
    // UI colors
    background: Color(0xFF0A0A0A), // Dark background as requested
    surface: Color(0xFF171717), // Slightly lighter surface
    content: Color(0xFFFFFFFF), // White content text as requested
    border: Color(0xFF242424), // Dark gray border
  );

  ColorPalette get palette => themeController.isDarkMode ? dark : light;
  ColorPalette getPalette(String mode) => mode == "dark" ? dark : light;
}
