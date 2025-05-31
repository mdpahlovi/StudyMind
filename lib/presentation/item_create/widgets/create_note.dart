import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/theme/colors.dart';

class CreateNote extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const CreateNote({super.key, required this.formKey});

  @override
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
  final QuillController noteController = QuillController.basic();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Note Content *', style: textTheme.labelLarge),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: colorPalette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorPalette.border),
          ),
          child: Column(
            children: [
              QuillSimpleToolbar(controller: noteController, config: const QuillSimpleToolbarConfig()),
              Divider(),
              QuillEditor.basic(
                controller: noteController,
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(16),
                  minHeight: 480,
                  customStyleBuilder: (attribute) {
                    return GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: colorPalette.contentDim,
                    );
                  },
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
