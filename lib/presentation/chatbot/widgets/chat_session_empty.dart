import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ChatSessionEmpty extends StatelessWidget {
  const ChatSessionEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(HugeIcons.strokeRoundedSadDizzy, size: 64),
          const SizedBox(height: 16),
          Text('Oops! No chat history yet', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
