import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final AnimationController fadeController;
  const TypingIndicator({super.key, required this.fadeController});

  @override
  State<TypingIndicator> createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<TypingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildDot(0, fadeController: widget.fadeController),
                const SizedBox(width: 4),
                buildDot(1, fadeController: widget.fadeController),
                const SizedBox(width: 4),
                buildDot(2, fadeController: widget.fadeController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, {required AnimationController fadeController}) {
    return AnimatedBuilder(
      animation: fadeController,
      builder: (context, child) {
        final value = (fadeController.value - (index * 0.2)).clamp(0.0, 1.0);
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(const Color(0xFFE5E7EB), const Color(0xFF6B7280), value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
