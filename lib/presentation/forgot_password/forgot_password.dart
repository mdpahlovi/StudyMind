import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/validators.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
    final ColorPalette colorPalette = AppColors.dark;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets paddings = MediaQuery.of(context).padding;
    final Size size = MediaQuery.of(context).size;

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height - paddings.top - paddings.bottom),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Intro Section
                      Column(
                        children: [
                          const SizedBox(height: 16),
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
                                if (!emailSent)
                                  TextSpan(
                                    text: ' Login',
                                    style: textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.login),
                                  ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                      // Form Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorPalette.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: emailSent
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
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
                                  CustomButton(text: 'Back to Login', onPressed: () => Get.toNamed(AppRoutes.login)),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        emailSent = false;
                                        emailController.clear();
                                      });
                                    },
                                    child: Text(
                                      'Try Different Email',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorPalette.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email Field
                                  CustomTextField(
                                    controller: emailController,
                                    label: 'Email Address',
                                    prefixIcon: 'mail',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validators.validateEmail,
                                  ),
                                  const SizedBox(height: 24),
                                  // Reset Button
                                  CustomButton(
                                    text: 'Send Reset Link',
                                    isLoading: isLoading,
                                    onPressed: () => Notification.success('Currently working on it'),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
