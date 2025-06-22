import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/theme/colors.dart';

class SessionCard extends StatelessWidget {
  final ChatSession session;
  final Function()? addSession;
  final Function()? removeSession;
  final List<ChatSession> selectedSessions;
  const SessionCard({
    super.key,
    required this.session,
    this.addSession,
    this.removeSession,
    this.selectedSessions = const [],
  });

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat.jm().format(date)}';
    } else if (difference.inDays < 7) {
      return '${DateFormat.EEEE().format(date)}, ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final isSelected = selectedSessions.contains(session);

    return Card(
      color: isSelected ? colorPalette.content.withAlpha(25) : colorPalette.surface,
      shape: RoundedRectangleBorder(
        side: isSelected ? BorderSide(width: 2, color: colorPalette.content) : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (selectedSessions.isEmpty) {
            chatController.navigateToSession(session);
          } else {
            if (addSession != null && removeSession != null) {
              isSelected ? removeSession!() : addSession!();
            }
          }
        },
        onLongPress: selectedSessions.isEmpty ? addSession : null,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: colorPalette.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(width: 62, height: 66, child: Icon(HugeIcons.strokeRoundedChatBot, size: 36)),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.title, style: textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      '${session.lastMessage!}\n',
                      style: textTheme.bodySmall?.copyWith(height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(getFormattedDate(session.lastMessageAt!), style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
