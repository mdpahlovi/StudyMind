import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_bubble.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_drawer.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_empty.dart';
import 'package:studymind/presentation/chatbot/widgets/chatbot_input.dart';
import 'package:studymind/presentation/chatbot/widgets/typing_indicator.dart';
import 'package:studymind/widgets/custom_back_button.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => ChatbotScreenState();
}

class ChatbotScreenState extends State<ChatbotScreen> with TickerProviderStateMixin {
  final ChatController chatController = Get.find<ChatController>();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late AnimationController fadeController;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    fadeController.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
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

              if (chatMessages.isEmpty) return const ChatbotEmpty();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chatMessages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == chatMessages.length && isTyping) {
                    return TypingIndicator(fadeController: fadeController);
                  }
                  return ChatBubble(message: chatMessages[index]);
                },
              );
            }),
          ),
          ChatbotInput(messageController: messageController, sendMessage: sendMessage),
        ],
      ),
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // messages.add(ChatMessage(text: text, isUser: true));
      isTyping = true;
    });

    messageController.clear();
    scrollToBottom();
    fadeController.repeat();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          // messages.add(ChatMessage(text: generateAIResponse(text), isUser: false));
          isTyping = false;
        });
        fadeController.stop();
        scrollToBottom();
      }
    });

    HapticFeedback.lightImpact();
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

  String generateAIResponse(String userMessage) {
    final responses = [
      "That's a great question! Let me help you understand that concept better.",
      "I'd be happy to assist you with that. Here's what you need to know...",
      "Interesting topic! Let me break this down for you step by step.",
      "Great question! This is an important concept in your studies.",
      "I can help you with that. Let me explain it in simple terms.",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
}
