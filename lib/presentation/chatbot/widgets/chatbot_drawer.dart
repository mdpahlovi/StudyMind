import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_list.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:uuid/uuid.dart';

class ChatbotDrawer extends StatelessWidget {
  const ChatbotDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
              child: Row(
                children: [
                  Text("Chat Sessions", style: textTheme.headlineMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: Obx(() {
                final chatSessions = chatController.chatSessions;
                final selectedChat = chatSessions.firstWhereOrNull((e) => e.uid == Get.parameters['uid']);

                if (chatSessions.isEmpty) return const ChatSessionEmpty();

                return ChatSessionList(sessions: chatSessions, selectedChat: selectedChat);
              }),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colorPalette.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.offNamed(AppRoutes.chatSession.replaceFirst(':uid', Uuid().v4()));
                    chatController.chatMessages.clear();
                    chatController.selectedSession.value = null;
                  },
                  icon: CustomIcon(icon: 'add', color: colorPalette.primary),
                  label: Text('New Chat', style: textTheme.titleMedium?.copyWith(color: colorPalette.primary)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorPalette.primary,
                    side: BorderSide(color: colorPalette.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
