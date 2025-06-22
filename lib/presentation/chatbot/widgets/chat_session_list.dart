import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/theme/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatSessionList extends StatelessWidget {
  final List<ChatSession> sessions;
  final ChatSession? selectedChat;
  const ChatSessionList({super.key, required this.sessions, this.selectedChat});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];

        return ListTile(
          selected: selectedChat == session,
          selectedTileColor: colorPalette.primary.withAlpha(20),
          onTap: () => chatController.navigateToSession(session, isReplace: true),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorPalette.primary.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(HugeIcons.strokeRoundedChatBot, color: colorPalette.primary),
          ),
          title: Text(session.title, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(timeago.format(session.lastMessageAt!), style: textTheme.bodySmall),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
