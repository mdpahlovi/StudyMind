import 'package:get/get.dart';
import 'package:studymind/theme/colors.dart';

class Notification {
  final ColorPalette colorPalette = AppColors().palette;

  void success(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: colorPalette.success,
      colorText: colorPalette.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void error(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: colorPalette.error,
      colorText: colorPalette.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void info(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: colorPalette.info,
      colorText: colorPalette.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void warning(String message) {
    Get.snackbar(
      'Warning',
      message,
      backgroundColor: colorPalette.warning,
      colorText: colorPalette.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
