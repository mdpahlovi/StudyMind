import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification {
  static void success(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void error(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void info(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void warning(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: Colors.yellow,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
