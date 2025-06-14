import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_list.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_loader.dart';
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorPalette.primary, colorPalette.secondary],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy_rounded, color: colorPalette.primary, size: 28),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chat History', style: textTheme.titleLarge),
                      Text('Your conversations', style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final chatSessions = chatController.chatSessions;
                final selectedChat = chatSessions.firstWhereOrNull((e) => e.uid == Get.parameters['uid']);

                if (chatController.isLoadingSessions.value) return const ChatSessionLoader();
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
