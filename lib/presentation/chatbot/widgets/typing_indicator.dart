import 'dart:math';

import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Typing', style: textTheme.bodyMedium),
          const SizedBox(width: 4),
          buildDot(0),
          const SizedBox(width: 4),
          buildDot(1),
          const SizedBox(width: 4),
          buildDot(2),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    final ColorPalette colorPalette = AppColors().palette;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animationValue = (animation.value + (index * 0.3)) % 1.0;
        final opacity = (sin(animationValue * pi * 2) + 1) / 2;

        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: colorPalette.content.withValues(alpha: 0.3 + (opacity * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
