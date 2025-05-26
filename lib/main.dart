import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/controllers/theme.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/theme.dart';

void main() async {
  await GetStorage.init();
  runApp(StudyMind());
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}

class StudyMind extends StatelessWidget {
  StudyMind({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StudyMind',
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme(mode: "light").theme,
      darkTheme: AppTheme(mode: "dark").theme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes().routes,
    );
  }
}
