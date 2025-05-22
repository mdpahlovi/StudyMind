import 'package:flutter/material.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color.withAlpha(50), shape: BoxShape.circle),
            child: Center(child: CustomIcon(icon: icon, color: color, size: 28)),
          ),
          const SizedBox(height: 8),
          Text(title, style: textTheme.bodySmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
