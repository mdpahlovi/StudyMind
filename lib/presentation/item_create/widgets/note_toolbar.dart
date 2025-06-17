import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class NoteToolbar extends StatefulWidget {
  const NoteToolbar({super.key});

  @override
  State<NoteToolbar> createState() => NoteToolbarState();
}

class NoteToolbarState extends State<NoteToolbar> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorPalette.surface,
        border: Border.symmetric(horizontal: BorderSide(color: colorPalette.border)),
      ),
      child: QuillSimpleToolbar(
        controller: itemCreateController.noteController,
        config: const QuillSimpleToolbarConfig(
          multiRowsDisplay: false,
          buttonOptions: QuillSimpleToolbarButtonOptions(
            undoHistory: QuillToolbarHistoryButtonOptions(iconData: HugeIcons.strokeRoundedUndo03),
            redoHistory: QuillToolbarHistoryButtonOptions(iconData: HugeIcons.strokeRoundedRedo03),
            bold: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextBold),
            italic: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextItalic),
            underLine: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextUnderline),
            strikeThrough: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextStrikethrough),
            inlineCode: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedSourceCode),
            subscript: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextSubscript),
            superscript: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedTextSuperscript),
            color: QuillToolbarColorButtonOptions(iconData: HugeIcons.strokeRoundedPaintBoard),
            backgroundColor: QuillToolbarColorButtonOptions(iconData: HugeIcons.strokeRoundedPaintBucket),
            clearFormat: QuillToolbarClearFormatButtonOptions(iconData: HugeIcons.strokeRoundedTextClear),
            listNumbers: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedLeftToRightListNumber),
            listBullets: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedLeftToRightListBullet),
            toggleCheckList: QuillToolbarToggleCheckListButtonOptions(iconData: HugeIcons.strokeRoundedCheckList),
            codeBlock: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedCode),
            quote: QuillToolbarToggleStyleButtonOptions(iconData: HugeIcons.strokeRoundedQuoteDown),
            indentIncrease: QuillToolbarIndentButtonOptions(iconData: HugeIcons.strokeRoundedTextIndentMore),
            indentDecrease: QuillToolbarIndentButtonOptions(iconData: HugeIcons.strokeRoundedTextIndentLess),
            linkStyle: QuillToolbarLinkStyleButtonOptions(iconData: HugeIcons.strokeRoundedLink04),
            search: QuillToolbarSearchButtonOptions(iconData: HugeIcons.strokeRoundedSearch01),
          ),
          showFontFamily: false,
          showFontSize: false,
          showAlignmentButtons: true,
        ),
      ),
    );
  }
}
