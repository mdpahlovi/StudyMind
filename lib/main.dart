import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studymind/core/supabase.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Supabase.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      getPages: AppRoutes.routes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
