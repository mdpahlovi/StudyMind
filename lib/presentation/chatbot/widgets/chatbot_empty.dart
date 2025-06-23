import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class ChatbotEmpty extends StatelessWidget {
  const ChatbotEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        print("constraints.maxHeight: ${constraints.maxHeight}");
        return SizedBox(
          height: constraints.maxHeight * 0.5, // 80% of available height
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: constraints.minHeight > 200 ? 120 : 100,
                  height: constraints.minHeight > 200 ? 120 : 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorPalette.primary, colorPalette.secondary, colorPalette.tertiary],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: constraints.minHeight > 200 ? 60 : 52,
                  ),
                ),
                SizedBox(height: constraints.minHeight > 200 ? 24 : 20),
                Text('How can I help you today?', style: textTheme.headlineLarge),
                if (constraints.maxHeight > 300) ...[
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
              ],
            ),
          ),
        );
      },
    );
  }
}
