import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_loader.dart';
import 'package:studymind/presentation/chatbot/widgets/session_options_sheet.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/chatbot/session_card.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/notification_button.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatSession> selectedSessions = [];

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    final ColorPalette colorPalette = AppColors().palette;

    return Scaffold(
      appBar: AppBar(
        leading: selectedSessions.isEmpty
            ? SizedBox()
            : IconButton(
                icon: const CustomIcon(icon: 'cancel', size: 28),
                onPressed: () => setState(() => selectedSessions.clear()),
              ),
        title: selectedSessions.isEmpty ? const Text('Chatbot') : Text('${selectedSessions.length}  chats'),
        actions: selectedSessions.isEmpty
            ? [NotificationButton()]
            : [
                IconButton(
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: colorPalette.content),
                    ),
                    child: chatController.chatSessions.length == selectedSessions.length
                        ? const CustomIcon(icon: 'tick', size: 16)
                        : const SizedBox(),
                  ),
                  onPressed: () {
                    if (chatController.chatSessions.length == selectedSessions.length) {
                      setState(() => selectedSessions.clear());
                    } else {
                      setState(() {
                        selectedSessions.clear();
                        selectedSessions.addAll(chatController.chatSessions);
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => Get.bottomSheet(SessionOptionsSheet(selectedSessions: selectedSessions)),
                ),
              ],
      ),
      body: Obx(() {
        final List<ChatSession> chatSessions = chatController.chatSessions;

        if (chatController.isLoadingSession.value) return ChatSessionLoader();
        if (chatSessions.isEmpty) return ChatSessionEmpty();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: chatSessions.length,
          itemBuilder: (context, index) {
            final session = chatSessions[index];
            return SessionCard(
              session: session,
              selectedSessions: selectedSessions,
              addSession: () => setState(() => selectedSessions.add(session)),
              removeSession: () => setState(() => selectedSessions.remove(session)),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        );
      }),
    );
  }
}
