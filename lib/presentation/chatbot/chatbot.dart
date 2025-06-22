import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_loader.dart';
import 'package:studymind/widgets/chatbot/session_card.dart';
import 'package:studymind/widgets/notification_button.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(leading: SizedBox(), title: const Text('Chatbot'), actions: [NotificationButton()]),
      body: Obx(() {
        final List<ChatSession> chatSessions = chatController.chatSessions;

        if (chatController.isLoadingSession.value) return ChatSessionLoader();
        if (chatSessions.isEmpty) return ChatSessionEmpty();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: chatSessions.length,
          itemBuilder: (context, index) {
            final session = chatSessions[index];
            return SessionCard(session: session);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        );
      }),
    );
  }
}
