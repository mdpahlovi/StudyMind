import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.value, required this.label, required this.subLabel, required this.color});

  final String value;
  final String label;
  final String subLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(value, style: textTheme.headlineLarge),
        SizedBox(height: 4),
        Text(label, style: textTheme.bodyMedium),
        Text(subLabel, style: textTheme.bodySmall),
      ],
    );
  }
}
