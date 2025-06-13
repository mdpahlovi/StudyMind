import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    itemCreateController.noteEditorState = EditorState.blank(withInitialText: true);
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
          decoration: BoxDecoration(
            color: colorPalette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.hasFocused ? colorPalette.primary : colorPalette.border,
              width: widget.hasFocused ? 2 : 1,
            ),
          ),
          child: AppFlowyEditor(
            editorState: itemCreateController.noteEditorState,
            focusNode: widget.focusNode,
            editorStyle: EditorStyle.mobile(
              padding: EdgeInsets.all(16),
              textStyleConfiguration: TextStyleConfiguration(
                text: GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
              ),
              cursorColor: colorPalette.primary,
              selectionColor: colorPalette.primary.withAlpha(128),
              dragHandleColor: colorPalette.primary,
            ),
            characterShortcutEvents: [...standardCharacterShortcutEvents],
            commandShortcutEvents: [...standardCommandShortcutEvents],
          ),
        ),
      ],
    );
  }
}
