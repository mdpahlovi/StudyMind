import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/mention_embed.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/presentation/chatbot/widgets/chat_content_dialog.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatbotInput extends StatefulWidget {
  final QuillController messageController;
  final void Function() onSendMessage;

  const ChatbotInput({super.key, required this.messageController, required this.onSendMessage});

  @override
  State<ChatbotInput> createState() => _ChatbotInputState();
}

class _ChatbotInputState extends State<ChatbotInput> {
  late FocusNode _focusNode;
  // To generate unique mention IDs

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.messageController.document.toPlainText();
    final selection = widget.messageController.selection;

    // Check if user typed @ and show dialog
    if (text.isNotEmpty && selection.baseOffset > 0) {
      final char = text[selection.baseOffset - 1];
      if (char == '@') {
        _showMentionDialog();
      }
    }
  }

  void _showMentionDialog() {
    Get.dialog(ChatContentDialog(onSelect: (chatContent) => _insertMention(chatContent)));
  }

  void _insertMention(ChatContent chatContent) {
    final selection = widget.messageController.selection;
    final currentOffset = selection.baseOffset;

    // Create ChatMention
    final mention = ChatMention(uid: chatContent.uid, name: chatContent.name, type: chatContent.type);

    // Remove the @ character
    widget.messageController.replaceText(currentOffset - 1, 1, '', TextSelection.collapsed(offset: currentOffset - 1));

    // Insert the mention embed
    widget.messageController.document.insert(
      currentOffset - 1,
      BlockEmbed.custom(MentionEmbed.fromChatMention(mention)),
    );

    // Move cursor after the mention and add a space
    widget.messageController.updateSelection(TextSelection.collapsed(offset: currentOffset), ChangeSource.local);

    // Add a space after the mention
    widget.messageController.document.insert(currentOffset, ' ');
    widget.messageController.updateSelection(TextSelection.collapsed(offset: currentOffset + 1), ChangeSource.local);
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
                controller: widget.messageController,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(16),
                  placeholder: 'Type here - use @ to mention content',
                  customStyles: QuillConstant.customStyles,
                  embedBuilders: [MentionEmbedBuilder()],
                ),
                focusNode: _focusNode,
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
                      onPressed: _showMentionDialog,
                      icon: CustomIcon(icon: 'add', size: 18),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton.filled(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => widget.onSendMessage(),
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
