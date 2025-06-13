import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(4)),
      child: Text(label.toUpperCase(), style: textTheme.labelSmall?.copyWith(fontSize: 10, color: color)),
    );
  }
}
