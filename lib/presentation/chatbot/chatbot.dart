import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_bubble.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_drawer.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_input.dart';
import 'package:studymind/presentation/chatbot/widgets/typing_indicator.dart';
import 'package:studymind/widgets/custom_back_button.dart';
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> with TickerProviderStateMixin {
  final ChatController chatController = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();
  late AnimationController fadeController;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    fadeController.dispose();
    chatController.messageController.clear();
    scrollController.dispose();
    super.dispose();
  }

  void requestQuery() async {
    final message = convertToString(chatController.messageController);

    if (message.isEmpty) return;

    chatController.chatMessages.add(
      ChatMessage(
        uid: Uuid().v4(),
        role: ChatMessageRole.user,
        message: message,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    chatController.messageController.clear();
    scrollToBottom();
    fadeController.repeat();

    chatController.requestQuery();

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        title: Obx(() {
          final selectedSession = chatController.selectedSession.value;
          if (selectedSession != null) {
            return Text(selectedSession.title);
          } else {
            return const Text('Chatbot');
          }
        }),
        actions: [
          Builder(
            builder: (context) => Center(
              child: IconButton(
                icon: const Icon(Icons.menu_rounded, size: 24),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ),
        ],
      ),
      endDrawer: ChatbotDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final chatMessages = chatController.chatMessages;
              final isGenAiTyping = chatController.isGenAiTyping.value;

              if (chatMessages.isEmpty) return const ChatbotEmpty();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatMessages.length + (isGenAiTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatMessages.length && isGenAiTyping) {
                    return TypingIndicator();
                  }
                  return ChatBubble(message: chatMessages[index]);
                },
              );
            }),
          ),
          ChatbotInput(onSendMessage: requestQuery),
        ],
      ),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

String convertToString(QuillController controller) {
  final buffer = StringBuffer();

  for (final op in controller.document.toDelta().toList()) {
    if (op.isInsert) {
      if (op.data is String) {
        buffer.write(op.data);
      } else if (op.data is Map) {
        final map = op.data as Map<String, dynamic>;
        if (map.containsKey('custom') && jsonDecode(map['custom']) is Map) {
          final customData = jsonDecode(map['custom']) as Map<String, dynamic>;
          if (customData.containsKey('mention')) {
            final mentionData = customData['mention'] as String;
            final parts = mentionData.split('|');
            buffer.write('@content {uid: ${parts[0]}, name: ${parts[1]}, type: ${parts[2]}}');
          }
        }
      }
    }
  }

  return buffer.toString();
}
