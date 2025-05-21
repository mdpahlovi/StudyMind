import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Get the theme mode from local storage
  bool get isDarkMode => _box.read(_key) ?? true;

  // Save the theme mode to local storage
  void saveThemeMode(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Toggle theme mode
  void changeTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isDarkMode);
    update(); // Notify listeners
  }

  // Initialize theme on app start
  void initTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
