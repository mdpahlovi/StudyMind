import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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

    final bubbleColor = isUser ? colorPalette.primary : colorPalette.accent;
    final textColor = isUser ? colorPalette.white : colorPalette.black;

    final avatarBg = isUser
        ? LinearGradient(colors: [colorPalette.primary, colorPalette.secondary])
        : LinearGradient(colors: [colorPalette.tertiary, colorPalette.accent]);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(gradient: avatarBg, borderRadius: BorderRadius.circular(16)),
              child: const Icon(HugeIcons.strokeRoundedChatBot, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 12),
                ),
              ),
              child: Text(message.message, style: textTheme.bodyMedium?.copyWith(color: textColor)),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(gradient: avatarBg, borderRadius: BorderRadius.circular(16)),
              child: Icon(HugeIcons.strokeRoundedUser, color: colorPalette.black, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}
