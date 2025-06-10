import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    itemCreateController.noteController.dispose();
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
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorPalette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorPalette.border),
          ),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: itemCreateController.noteController,
                config: const QuillSimpleToolbarConfig(),
              ),
              Divider(),
              QuillEditor.basic(
                controller: itemCreateController.noteController,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(16),
                  minHeight: 480,
                  placeholder: 'Start writing your note...',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
