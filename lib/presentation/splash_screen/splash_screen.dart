import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('StudyMind', style: textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colorPalette.primary),
              onPressed: () => Get.toNamed(AppRoutes.home),
              child: Text('Home', style: textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
