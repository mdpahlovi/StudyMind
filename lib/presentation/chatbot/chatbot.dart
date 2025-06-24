import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_session_loader.dart';
import 'package:studymind/presentation/chatbot/widgets/session_options_sheet.dart';
import 'package:studymind/widgets/chatbot/session_card.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/notification_button.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        if (chatController.selectedSessions.isNotEmpty) {
          chatController.selectedSessions.clear();
        } else {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => chatController.fetchChatSessions(),
        child: Scaffold(
          appBar: AppBar(
            leading: Obx(() {
              final selectedSessions = chatController.selectedSessions;

              return selectedSessions.isEmpty
                  ? SizedBox()
                  : IconButton(
                      icon: const CustomIcon(icon: 'cancel', size: 28),
                      onPressed: () => selectedSessions.clear(),
                    );
            }),
            title: Obx(() {
              final selectedSessions = chatController.selectedSessions;

              if (selectedSessions.isEmpty) {
                return const Text('Chatbot');
              } else {
                return Text('${selectedSessions.length}  chats');
              }
            }),
            actions: [
              Obx(() {
                final chatSessions = chatController.chatSessions;
                final selectedSessions = chatController.selectedSessions;

                if (selectedSessions.isEmpty) {
                  return NotificationButton();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: chatSessions.length == selectedSessions.length
                            ? Icon(HugeIcons.strokeRoundedCheckmarkCircle01, size: 22)
                            : Icon(HugeIcons.strokeRoundedCircle, size: 22),
                        onPressed: () {
                          if (chatSessions.length == selectedSessions.length) {
                            selectedSessions.clear();
                          } else {
                            selectedSessions.clear();
                            selectedSessions.addAll(chatSessions);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => Get.bottomSheet(SessionOptionsSheet(selectedSessions: selectedSessions)),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
          body: Obx(() {
            final chatSessions = chatController.chatSessions;

            if (chatController.isLoadingSession.value) return ChatSessionLoader();
            if (chatSessions.isEmpty) return ChatSessionEmpty();

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: chatSessions.length,
              itemBuilder: (context, index) => SessionCard(session: chatSessions[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            );
          }),
        ),
      ),
    );
  }
}
