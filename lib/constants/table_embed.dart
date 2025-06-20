import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart';
import 'package:studymind/theme/colors.dart';

class TableData {
  final List<String> headers;
  final List<List<String>> rows;

  TableData({required this.headers, required this.rows});
}

class TableEmbed implements EmbedBuilder {
  @override
  String get key => EmbeddableTable.tableType;

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget, alignment: PlaceholderAlignment.middle);
  }

  @override
  String toPlainText(Embed node) {
    final tableMarkdown = node.value.data as String;
    final tableData = parseTableMarkdown(tableMarkdown);

    if (tableData.headers.isEmpty) {
      return '[Table]';
    }

    final buffer = StringBuffer();

    buffer.writeln(tableData.headers.join(' | '));
    buffer.writeln('-' * (tableData.headers.join(' | ').length));

    for (final row in tableData.rows) {
      final paddedRow = List<String>.generate(
        tableData.headers.length,
        (index) => index < row.length ? row[index] : '',
      );
      buffer.writeln(paddedRow.join(' | '));
    }

    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final tableMarkdown = embedContext.node.value.data as String;
    final tableData = parseTableMarkdown(tableMarkdown);

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Table(
      border: TableBorder.all(color: colorPalette.border, borderRadius: BorderRadius.all(Radius.circular(12))),
      children: [
        TableRow(
          children: tableData.headers.map((header) {
            return TableCell(
              child: Container(
                constraints: BoxConstraints(minHeight: 36),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                alignment: Alignment.centerLeft,
                child: Text(header, style: textTheme.titleSmall),
              ),
            );
          }).toList(),
        ),
        ...tableData.rows.map((row) {
          return TableRow(
            children: row.map((cell) {
              return TableCell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Text(cell, style: textTheme.labelMedium),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ],
    );
  }

  TableData parseTableMarkdown(String markdown) {
    final lines = markdown.trim().split('\n');

    if (lines.isEmpty) {
      return TableData(headers: [], rows: []);
    }

    final headers = lines[0].split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final rows = <List<String>>[];
    for (int i = 2; i < lines.length; i++) {
      final row = lines[i].split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      if (row.isNotEmpty) {
        rows.add(row);
      }
    }

    return TableData(headers: headers, rows: rows);
  }
}
