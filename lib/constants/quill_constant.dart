import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studymind/theme/colors.dart';

class QuillConstant {
  static final ColorPalette colorPalette = AppColors().palette;
  static final DefaultStyles customStyles = DefaultStyles(
    placeHolder: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.contentDim, fontSize: 14),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(4, 4),
      const VerticalSpacing(2, 2),
      const BoxDecoration(),
    ),
    paragraph: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(4, 4),
      const VerticalSpacing(2, 2),
      const BoxDecoration(),
    ),
    h1: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 30, fontWeight: FontWeight.bold),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(8, 6),
      const VerticalSpacing(4, 4),
      const BoxDecoration(),
    ),
    h2: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 24, fontWeight: FontWeight.bold),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(7, 5),
      const VerticalSpacing(3, 3),
      const BoxDecoration(),
    ),
    h3: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 20, fontWeight: FontWeight.w600),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(6, 4),
      const VerticalSpacing(3, 3),
      const BoxDecoration(),
    ),
    h4: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 18, fontWeight: FontWeight.w600),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(5, 3),
      const VerticalSpacing(2, 2),
      const BoxDecoration(),
    ),
    h5: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 16, fontWeight: FontWeight.w500),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(4, 3),
      const VerticalSpacing(2, 2),
      const BoxDecoration(),
    ),
    h6: DefaultTextBlockStyle(
      GoogleFonts.outfit(color: colorPalette.content, fontSize: 14, fontWeight: FontWeight.w500),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(3, 2),
      const VerticalSpacing(1, 1),
      const BoxDecoration(),
    ),
    lists: DefaultListBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(4, 4),
      const VerticalSpacing(2, 2),
      const BoxDecoration(),
      CustomCheckboxBuilder(),
    ),
    code: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      const HorizontalSpacing(0, 0),
      const VerticalSpacing(6, 6),
      const VerticalSpacing(3, 3),
      BoxDecoration(color: colorPalette.content.withAlpha(25), borderRadius: BorderRadius.circular(8)),
    ),
    inlineCode: InlineCodeStyle(
      style: GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      backgroundColor: colorPalette.content.withAlpha(25),
      radius: const Radius.circular(4),
    ),
    quote: DefaultTextBlockStyle(
      GoogleFonts.plusJakartaSans(color: colorPalette.content, fontSize: 14),
      const HorizontalSpacing(8, 8),
      const VerticalSpacing(6, 6),
      const VerticalSpacing(3, 3),
      BoxDecoration(color: colorPalette.content.withAlpha(25), borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class CustomCheckboxBuilder extends QuillCheckboxBuilder {
  @override
  Widget build({required BuildContext context, required bool isChecked, required ValueChanged<bool> onChanged}) {
    return Checkbox(value: isChecked, onChanged: (value) => onChanged(value ?? false), shape: const CircleBorder());
  }
}
