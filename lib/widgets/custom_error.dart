import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/routes/routes.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomError({super.key, this.errorDetails, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(HugeIcons.strokeRoundedSadDizzy, size: 42, color: const Color(0xFFD32F2F)),
                const SizedBox(height: 8),
                Text(
                  "Something went wrong",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF262626)),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  child: const Text(
                    'We encountered an unexpected error while processing your request.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF525252), // neutral-600
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    bool canBeBack = Navigator.canPop(context);
                    if (canBeBack) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.pushNamed(context, AppRoutes.splashScreen);
                    }
                  },
                  icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
                  label: const Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
