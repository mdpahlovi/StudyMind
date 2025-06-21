import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(12.0)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(title, style: textTheme.bodyMedium, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(value, style: textTheme.displayMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
