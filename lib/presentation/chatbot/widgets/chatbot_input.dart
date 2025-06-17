import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/core/logger.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_content_dialog.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatbotInput extends StatelessWidget {
  final TextEditingController messageController;
  final void Function() onSendMessage;
  const ChatbotInput({super.key, required this.messageController, required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 256),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: TextField(
                controller: messageController,
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'Chat with StudyMind Bot...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: 40,
                color: colorPalette.surface,
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    IconButton.outlined(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => Get.dialog(
                        ChatContentDialog(
                          onContentSelected: (content) {
                            logger.d(content);
                          },
                        ),
                      ),
                      icon: CustomIcon(icon: 'add', size: 18),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton.filled(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => onSendMessage(),
                      icon: CustomIcon(icon: 'sent', size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
