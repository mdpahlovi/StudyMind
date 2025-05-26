import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeOutBack));
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> handleResetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoading = false;
        emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorPalette.primary, colorPalette.secondary],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Intro Section
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: colorPalette.content.withAlpha(50),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(HugeIcons.strokeRoundedResetPassword, size: 48, color: colorPalette.content),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            emailSent ? 'Check Your Email' : 'Forgot Password',
                            style: textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: emailSent ? 'Enter the OTP sent to your email' : 'Remember your password?',
                                  style: textTheme.bodyMedium,
                                ),
                                emailSent
                                    ? TextSpan()
                                    : TextSpan(
                                      text: ' Login',
                                      style: textTheme.bodyMedium,
                                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.login),
                                    ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorPalette.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          emailSent
                              ? Column(
                                children: [
                                  Icon(Icons.check_circle_outline, size: 80, color: Colors.green[400]),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Email Sent Successfully!',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Please check your inbox and follow the instructions to reset your password.',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  CustomButton(
                                    text: 'Back to Login',
                                    onPressed: () {
                                      setState(() {
                                        emailSent = false;
                                        emailController.clear();
                                      });
                                    },
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  // Email Field
                                  CustomTextField(
                                    controller: emailController,
                                    label: 'Email Address',
                                    prefixIcon: 'mail',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: validateEmail,
                                  ),
                                  const SizedBox(height: 24),
                                  // Reset Button
                                  CustomButton(
                                    text: 'Send OTP',
                                    isLoading: isLoading,
                                    onPressed: () => Notification().success('Currently working on it'),
                                  ),
                                ],
                              ),
                    ),
                    SizedBox(height: 182),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
