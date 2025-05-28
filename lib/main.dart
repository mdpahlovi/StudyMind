import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  runApp(const StudyMind());
}

class StudyMind extends StatelessWidget {
  const StudyMind({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StudyMind',
      themeMode: ThemeMode.dark,
      theme: AppTheme(mode: "light").theme,
      darkTheme: AppTheme(mode: "dark").theme,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes().routes,
    );
  }
}
