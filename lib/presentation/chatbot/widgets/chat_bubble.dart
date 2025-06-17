import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/theme/colors.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isUser = message.role == ChatMessageRole.user;
    final markdownTODelta = MarkdownToDelta(markdownDocument: md.Document(encodeHtml: false));

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: isUser
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: colorPalette.primary, borderRadius: BorderRadius.circular(12)),
              child: Text(
                message.message,
                style: textTheme.bodyMedium?.copyWith(color: colorPalette.white, height: 1.25),
              ),
            )
          : QuillEditor.basic(
              controller: QuillController(
                document: Document.fromDelta(markdownTODelta.convert(message.message)),
                selection: const TextSelection.collapsed(offset: 0),
                readOnly: true,
              ),
              config: QuillEditorConfig(customStyles: QuillConstant.customStyles),
            ),
    );
  }
}
