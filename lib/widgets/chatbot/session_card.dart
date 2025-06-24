import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/main.dart';
import 'package:studymind/presentation/chatbot/widgets/session_options_sheet.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class SessionCard extends StatelessWidget {
  final ChatSession session;
  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.find<MainController>();
    final ChatController chatController = Get.find<ChatController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selectedSessions = chatController.selectedSessions;
      final isSelected = selectedSessions.contains(session);

      return Card(
        color: isSelected ? colorPalette.primary.withAlpha(25) : colorPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected ? BorderSide(color: colorPalette.primary.withAlpha(50), width: 1) : BorderSide.none,
        ),
        child: InkWell(
          onTap: () {
            if (selectedSessions.isEmpty) {
              chatController.navigateToSession(session);
            } else {
              isSelected ? selectedSessions.remove(session) : selectedSessions.add(session);
            }
          },
          onLongPress: selectedSessions.isEmpty ? () => selectedSessions.add(session) : null,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8, top: 8, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorPalette.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorPalette.primary.withAlpha(100), width: 1),
                  ),
                  child: Icon(HugeIcons.strokeRoundedChatBot, color: colorPalette.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.title,
                              style: textTheme.titleMedium?.copyWith(height: 1.25),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          selectedSessions.isNotEmpty
                              ? CustomIconButton(
                                  onTap: () =>
                                      isSelected ? selectedSessions.remove(session) : selectedSessions.add(session),
                                  child: isSelected
                                      ? Icon(HugeIcons.strokeRoundedCheckmarkCircle01, size: 20)
                                      : Icon(HugeIcons.strokeRoundedCircle, size: 20),
                                )
                              : Obx(() {
                                  if (mainController.selectedIndex == 0) {
                                    return CustomIconButton(child: Icon(HugeIcons.strokeRoundedArrowRight01, size: 20));
                                  } else {
                                    return CustomIconButton(
                                      onTap: () => Get.bottomSheet(SessionOptionsSheet(selectedSessions: [session])),
                                      child: Icon(Icons.more_vert, size: 20),
                                    );
                                  }
                                }),
                        ],
                      ),
                      if (session.lastMessage != null && session.lastMessage!.isNotEmpty)
                        Text(
                          '${session.lastMessage!}\n',
                          style: textTheme.bodyMedium?.copyWith(color: colorPalette.contentDim, height: 1.25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedClock01,
                            size: 14,
                            color: colorPalette.contentDim.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Text(
                              timeago.format(session.lastMessageAt!),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorPalette.contentDim.withValues(alpha: 0.7),
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
