import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/auth.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/validators.dart';
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
  final AuthController authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.validate()) {
      await authController.login(emailController.text, passwordController.text);
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
                                  style: textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.register),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Email Field
                            CustomTextField(
                              controller: emailController,
                              label: 'Email',
                              prefixIcon: 'mail',
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 16),
                            // Password Field
                            CustomTextField(
                              controller: passwordController,
                              label: 'Password',
                              prefixIcon: 'lock',
                              isPassword: true,
                              validator: Validators.validatePassword,
                            ),
                            const SizedBox(height: 24),
                            // Login Button
                            Obx(
                              () => CustomButton(
                                text: 'Login',
                                isLoading: authController.isLogging.value,
                                onPressed: handleLogin,
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
                            SocialButton(
                              text: 'Google',
                              color: Colors.red,
                              onPressed: () => Notification.error(
                                'Please use email and password login.\nOr user "guest@gmail.com" and "123456"',
                              ),
                            ),
                            const SizedBox(height: 16),
                            SocialButton(
                              text: 'Facebook',
                              color: Colors.blue,
                              onPressed: () => Notification.error(
                                'Please use email and password login.\nOr user "guest@gmail.com" and "123456"',
                              ),
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
      ),
    );
  }
}
