import 'package:flutter/material.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({super.key, required this.label, this.icon, required this.color});

  final String label;
  final String? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[CustomIcon(icon: icon!, color: color, size: 12), const SizedBox(width: 4)],
          Text(label, style: textTheme.labelSmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}
