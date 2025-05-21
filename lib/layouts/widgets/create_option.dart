import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CreateOption extends StatelessWidget {
  const CreateOption({super.key, this.onTap, required this.title, required this.icon, required this.color});

  final void Function()? onTap;
  final String title;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(border: Border.all(color: colorPalette.border), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(8)),
              child: CustomIcon(icon: icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(title, style: textTheme.titleMedium),
            const Spacer(),
            CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 16),
          ],
        ),
      ),
    );
  }
}
