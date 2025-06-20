import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/constants/table_embed.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/core/utils.dart';

class ViewNote extends StatelessWidget {
  final LibraryItem item;
  const ViewNote({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: QuillController(
        document: Document.fromDelta(markdownTODelta.convert(item.metadata?['notes'] ?? '')),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      ),
      config: QuillEditorConfig(customStyles: QuillConstant.customStyles, embedBuilders: [TableEmbed()]),
    );
  }
}
