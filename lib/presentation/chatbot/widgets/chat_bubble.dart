import 'package:flutter/material.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/theme/colors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isUser = message.role == ChatMessageRole.user;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: isUser
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: colorPalette.primary, borderRadius: BorderRadius.circular(12)),
              child: Text(
                message.message,
                style: textTheme.bodyMedium?.copyWith(color: colorPalette.white, height: 1.2),
              ),
            )
          : Text(message.message, style: textTheme.bodyMedium?.copyWith(height: 1.2)),
    );
  }
}
