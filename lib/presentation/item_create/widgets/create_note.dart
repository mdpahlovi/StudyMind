import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/quill_constant.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class CreateNote extends StatefulWidget {
  final FocusNode focusNode;
  final bool hasFocused;
  const CreateNote({super.key, required this.focusNode, required this.hasFocused});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  void dispose() {
    itemCreateController.noteController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note Content', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          height: 480,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorPalette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.hasFocused ? colorPalette.primary : colorPalette.border,
              width: widget.hasFocused ? 2 : 1,
            ),
          ),
          child: QuillEditor.basic(
            focusNode: widget.focusNode,
            controller: itemCreateController.noteController,
            config: QuillEditorConfig(placeholder: 'Type your note here...', customStyles: QuillConstant.customStyles),
          ),
        ),
      ],
    );
  }
}
