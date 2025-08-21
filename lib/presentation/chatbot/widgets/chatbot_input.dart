import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/mention_embed.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_content_dialog.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatbotInput extends StatefulWidget {
  final void Function() onSendMessage;

  const ChatbotInput({super.key, required this.onSendMessage});

  @override
  State<ChatbotInput> createState() => ChatbotInputState();
}

class ChatbotInputState extends State<ChatbotInput> {
  final LibraryController libraryController = Get.find<LibraryController>();
  final ChatController chatController = Get.find<ChatController>();
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    chatController.messageController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    chatController.messageController.removeListener(onTextChanged);
    focusNode.dispose();
    super.dispose();
  }

  void onTextChanged() {
    final text = chatController.messageController.document.toPlainText();
    final selection = chatController.messageController.selection;

    // Check if user typed @ and show dialog
    if (text.isNotEmpty && selection.baseOffset > 0) {
      final char = text[selection.baseOffset - 1];
      if (char == '@') showMentionDialog(true);
    }
  }

  void showMentionDialog(bool? hasAtSymbol) {
    Get.bottomSheet(
      ChatContentDialog(
        chatContents: libraryController.libraryItemsWithPath,
        onSelect: (chatContent) => insertMention(chatContent, hasAtSymbol),
      ),
    );
  }

  void insertMention(LibraryItemWithPath chatContent, bool? hasAtSymbol) {
    final selection = chatController.messageController.selection;
    final currentOffset = selection.baseOffset;

    // Remove the @ character if it exists
    if (hasAtSymbol == true) {
      chatController.messageController.replaceText(currentOffset - 1, 1, '', TextSelection.collapsed(offset: currentOffset - 1));
    }

    // Insert the mention embed
    chatController.messageController.document.insert(
      hasAtSymbol == true ? currentOffset - 1 : currentOffset,
      EmbeddableMention.fromChatMention(ChatMention(uid: chatContent.uid, name: chatContent.name, type: chatContent.type)),
    );

    // Insert a space and move the cursor
    chatController.messageController.document.insert(hasAtSymbol == true ? currentOffset : currentOffset + 1, ' ');
    chatController.messageController.updateSelection(
      TextSelection.collapsed(offset: hasAtSymbol == true ? currentOffset + 1 : currentOffset + 2),
      ChangeSource.local,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 256),
        decoration: BoxDecoration(
          color: colorPalette.surface,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: QuillEditor.basic(
                controller: chatController.messageController,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(16),
                  placeholder: 'Type here - use @ to mention content',
                  customStyles: QuillConstant.customStyles,
                  embedBuilders: [MentionEmbedBuilder()],
                ),
                focusNode: focusNode,
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
                      onPressed: () => showMentionDialog(false),
                      icon: CustomIcon(icon: 'add', size: 18),
                    ),
                    Expanded(child: SizedBox()),
                    Obx(() {
                      final isTyping = chatController.isGenAiTyping.value;

                      return IconButton.filled(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: isTyping ? null : () => widget.onSendMessage(),
                        icon: CustomIcon(icon: 'sent', size: 18),
                      );
                    }),
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
