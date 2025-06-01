import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomError({super.key, this.errorDetails, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(HugeIcons.strokeRoundedSadDizzy, size: 64, color: const Color(0xFFD32F2F)),
              const SizedBox(height: 16),
              Text("Something went wrong", style: textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                width: 320,
                child: Text(
                  'We encountered an unexpected error while processing your request.',
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                icon: CustomIcon(icon: 'arrowLeft'),
                label: Text('Back', style: textTheme.titleMedium),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPalette.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
