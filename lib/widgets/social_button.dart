import 'package:flutter/material.dart';
import 'package:studymind/widgets/custom_icon.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withAlpha(128)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: color.withAlpha(26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(icon: text.toLowerCase(), size: 16, color: color),
            const SizedBox(width: 6),
            Text(text, style: textTheme.titleSmall?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
