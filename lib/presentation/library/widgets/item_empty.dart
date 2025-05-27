import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ItemEmpty extends StatelessWidget {
  const ItemEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(HugeIcons.strokeRoundedSadDizzy, size: 64),
          const SizedBox(height: 16),
          Text('Oops! No items found', style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Tap + button to create or upload items', style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
