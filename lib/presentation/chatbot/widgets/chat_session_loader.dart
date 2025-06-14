import 'package:flutter/material.dart';

class ChatSessionLoader extends StatelessWidget {
  const ChatSessionLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 64, width: 64, padding: const EdgeInsets.all(5), child: CircularProgressIndicator()),
          const SizedBox(height: 16),
          Text('Loading chat history...', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
