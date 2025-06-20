import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studymind/constants/created_embed.dart';
import 'package:studymind/constants/mention_embed.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/constants/table_embed.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/core/utils.dart';
import 'package:studymind/theme/colors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final bool isUser = message.role == ChatMessageRole.user;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: isUser
          ? Container(
              decoration: BoxDecoration(color: colorPalette.primary, borderRadius: BorderRadius.circular(12)),
              child: QuillEditor.basic(
                controller: QuillController(
                  document: Document.fromDelta(markdownTODelta.convert(message.message)),
                  selection: const TextSelection.collapsed(offset: 0),
                  readOnly: true,
                ),
                config: QuillEditorConfig(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 6),
                  customStyles: QuillConstant.customStyles,
                  embedBuilders: [TableEmbed(), MentionOutlineEmbedBuilder()],
                ),
              ),
            )
          : QuillEditor.basic(
              controller: QuillController(
                document: Document.fromDelta(markdownTODelta.convert(message.message)),
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: true,
              ),
              config: QuillEditorConfig(
                customStyles: QuillConstant.customStyles,
                embedBuilders: [TableEmbed(), MentionEmbedBuilder(), CreatedEmbedBuilder()],
              ),
            ),
    );
  }
}
