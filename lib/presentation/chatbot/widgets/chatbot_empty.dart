import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class ChatbotEmpty extends StatelessWidget {
  const ChatbotEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorPalette.primary, colorPalette.secondary],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 32),
          Text('How can I help you today?', style: textTheme.headlineLarge),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ask me anything about your studies, homework, or any topic you would like to learn about.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
