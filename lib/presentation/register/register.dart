import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_button.dart';
import 'package:studymind/widgets/custom_text_field.dart';
import 'package:studymind/widgets/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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

  Future<void> handleRegister() async {
    if (formKey.currentState!.validate()) {
      await authController.register(emailController.text, passwordController.text, nameController.text);
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
                            child: Icon(HugeIcons.strokeRoundedUserAdd02, size: 48, color: colorPalette.content),
                          ),
                          const SizedBox(height: 16),
                          Text('Create Account', style: textTheme.displayMedium, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'Already have an account?', style: textTheme.bodyMedium),
                                TextSpan(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name Field
                          CustomTextField(
                            controller: nameController,
                            label: 'Full Name',
                            prefixIcon: 'profile',
                            validator: validateName,
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 24),
                          // Register Button
                          Obx(
                            () => CustomButton(
                              text: 'Register',
                              isLoading: authController.isLogging.value,
                              onPressed: handleRegister,
                            ),
                          ),
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
      ),
    );
  }
}
