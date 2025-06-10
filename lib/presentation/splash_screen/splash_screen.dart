import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();

  late Animation<double> rotateAnimation;
  late AnimationController rotateController;

  @override
  void initState() {
    super.initState();
    initAnimations();
    startAnimations();

    Timer(Duration(seconds: 3), () {
      if (mounted) authController.checkAuthStatus();
    });
  }

  void initAnimations() {
    rotateController = AnimationController(duration: Duration(milliseconds: 3000), vsync: this);

    rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: rotateController, curve: Curves.easeInOut));
  }

  void startAnimations() {
    rotateController.repeat();
  }

  @override
  void dispose() {
    rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors.dark;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () async => authController.checkAuthStatus(),
      child: Scaffold(
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
                          child: InkWell(
                            onTap: () => authController.checkAuthStatus(),
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Image.asset('assets/images/logo.png'),
                            ),
                          ),
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
                      Text(
                        'Copyright© ${DateTime.now().year} StudyMind',
                        style: textTheme.bodySmall?.copyWith(color: colorPalette.content),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
