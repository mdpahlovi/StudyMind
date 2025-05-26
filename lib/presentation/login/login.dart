import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';
import 'package:studymind/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> handleLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        height: double.infinity,
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: colorPalette.content.withAlpha(50), shape: BoxShape.circle),
                          child: Icon(HugeIcons.strokeRoundedUser, size: 48, color: colorPalette.content),
                        ),
                        const SizedBox(height: 16),
                        Text('Welcome Back!', style: textTheme.displayMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Don\'t have an account?', style: textTheme.bodyMedium),
                              TextSpan(
                                text: ' Register',
                                style: textTheme.bodyMedium,
                                recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.register),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Form Container
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: colorPalette.background, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        CustomTextField(
                          controller: emailController,
                          label: 'Email',
                          prefixIcon: 'mail',
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        CustomTextField(
                          controller: passwordController,
                          label: 'Password',
                          prefixIcon: 'lock',
                          isPassword: true,
                          validator: validatePassword,
                        ),
                        const SizedBox(height: 16),
                        // Confirm Password Field
                        CustomTextField(
                          controller: confirmPasswordController,
                          label: 'Confirm Password',
                          prefixIcon: 'lock',
                          isPassword: true,
                          validator: validateConfirmPassword,
                        ),
                        const SizedBox(height: 20),
                        // Forgot Password
                        InkWell(
                          onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                          child: Text(
                            'Forgot Password?',
                            style: textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Login Button
                        CustomButton(text: 'Login', isLoading: isLoading, onPressed: handleLogin),
                        const SizedBox(height: 20),
                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: colorPalette.border)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('or continue with', style: textTheme.labelSmall),
                            ),
                            Expanded(child: Divider(color: colorPalette.border)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Social Login Buttons
                        Row(
                          children: [
                            Expanded(child: SocialButton(text: 'Google', color: Colors.red, onPressed: () {})),
                            const SizedBox(width: 16),
                            Expanded(child: SocialButton(text: 'Facebook', color: Colors.blue, onPressed: () {})),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
