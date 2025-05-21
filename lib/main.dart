import 'package:flutter/material.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/theme.dart';

void main() {
  runApp(const StudyMind());
}

class StudyMind extends StatelessWidget {
  const StudyMind({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMind',
      themeMode: ThemeMode.dark,
      theme: AppTheme('light').theme,
      darkTheme: AppTheme('dark').theme,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}
