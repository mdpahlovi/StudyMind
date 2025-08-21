import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatContentDialog extends StatelessWidget {
  final List<LibraryItemWithPath> chatContents;
  final Function(LibraryItemWithPath) onSelect;

  const ChatContentDialog({super.key, required this.chatContents, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Fixed header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text("Select Content", style: textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                ),
              ],
            ),
          ),
          Divider(),
          // Scrollable content
          chatContents.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(HugeIcons.strokeRoundedSadDizzy, size: 64),
                      const SizedBox(height: 16),
                      Text('Oops! No content found', style: textTheme.bodyMedium),
                    ],
                  ),
                )
              : Flexible(
                  child: SingleChildScrollView(
                    child: Column(children: chatContents.map((content) => buildChatContent(context, content, onSelect)).toList()),
                  ),
                ),
        ],
      ),
    );
  }
}

Widget buildChatContent(BuildContext context, LibraryItemWithPath content, Function(LibraryItemWithPath) onSelect) {
  final TextTheme textTheme = Theme.of(context).textTheme;

  if (content.type == ItemType.folder) {
    return ExpansionTile(
      leading: buildLeading(context, content),
      title: Text(content.name, style: textTheme.titleMedium),
      children: content.children.map((content) => buildChatContent(context, content, onSelect)).toList(),
    );
  } else {
    return ListTile(
      onTap: () {
        Get.back();
        onSelect(content);
      },
      leading: buildLeading(context, content),
      title: Text(content.name, style: textTheme.titleMedium),
    );
  }
}

Widget buildLeading(BuildContext context, LibraryItemWithPath content) {
  final Color color = ItemTypeStyle.getStyle(content.type).color;
  final String icon = ItemTypeStyle.getStyle(content.type).icon;

  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(8)),
    child: CustomIcon(icon: icon, color: color),
  );
}
