import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late Animation<double> rotateAnimation;
  late AnimationController rotateController;

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    initializeAnimations();
    startAnimations();
    handleAuthRedirect();
  }

  void initializeAnimations() {
    rotateController = AnimationController(duration: Duration(milliseconds: 3000), vsync: this);

    //I want circular motion
    rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: rotateController, curve: Curves.easeInOut));
  }

  void startAnimations() {
    rotateController.repeat();
  }

  void handleAuthRedirect() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!authController.isLoading.value) {
        if (authController.isLoggedIn.value) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      }
    });
  }

  @override
  void dispose() {
    rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorPalette.primary, colorPalette.secondary, colorPalette.tertiary],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: colorPalette.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: colorPalette.black.withAlpha(25), blurRadius: 20, offset: Offset(0, 10)),
                          ],
                        ),
                        child: Icon(Icons.school_rounded, size: 80, color: Colors.white),
                      ),
                      SizedBox(height: 36),
                      // App Title
                      Text('StudyMind', style: textTheme.displayMedium),
                      SizedBox(height: 12),
                      // Subtitle
                      Text('Your Smart Learning Companion', style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () =>
                          authController.isLoading.value
                              ? Column(
                                children: [
                                  // Custom Loading Animation
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: colorPalette.white.withAlpha(125), width: 3),
                                          ),
                                        ),
                                        AnimatedBuilder(
                                          animation: rotateController,
                                          builder: (context, child) {
                                            return Transform.rotate(
                                              angle: rotateController.value * 6.28,
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border(
                                                    top: BorderSide(color: Colors.white, width: 3),
                                                    right: BorderSide.none,
                                                    bottom: BorderSide.none,
                                                    left: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Initializing your learning experience...', style: textTheme.bodyMedium),
                                ],
                              )
                              : Container(),
                    ),
                    SizedBox(height: 48),
                    // Bottom Brand Text
                    Text('Powered by AI Technology', style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
