import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';
import 'package:studymind/routes/routes.dart';

class ChatSessionEmpty extends StatelessWidget {
  const ChatSessionEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(HugeIcons.strokeRoundedSadDizzy, size: 64),
          const SizedBox(height: 16),
          Text('Oops! No chat sessions yet', style: textTheme.bodyMedium),
          if (Get.currentRoute == AppRoutes.home) ...[
            const SizedBox(height: 8),
            Text('Tap + button to create new chat session', style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
