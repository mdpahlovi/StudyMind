import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/theme/colors.dart';

class QuillConstant {
  static final ColorPalette colorPalette = AppColors().palette;
  static final DefaultStyles customStyles = DefaultStyles(
    placeHolder: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.contentDim, fontSize: 14),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    paragraph: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h1: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 24),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h2: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 20),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    h3: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 16),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
    ),
    lists: DefaultListBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(),
      CustomCheckboxBuilder(),
    ),
    code: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      HorizontalSpacing.zero,
      VerticalSpacing.zero,
      VerticalSpacing.zero,
      BoxDecoration(color: colorPalette.content.withAlpha(25), borderRadius: BorderRadius.circular(8)),
    ),
    inlineCode: InlineCodeStyle(
      style: GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      backgroundColor: colorPalette.content.withAlpha(25),
      radius: Radius.circular(4),
    ),
  );
}

class CustomCheckboxBuilder extends QuillCheckboxBuilder {
  @override
  Widget build({required BuildContext context, required bool isChecked, required ValueChanged<bool> onChanged}) {
    return Checkbox(value: isChecked, onChanged: (value) => onChanged(value ?? false), shape: const CircleBorder());
  }
}
