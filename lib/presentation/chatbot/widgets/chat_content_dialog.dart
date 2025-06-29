import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/chat.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ChatContentDialog extends StatefulWidget {
  final List<LibraryItemWithPath> chatContents;
  final Function(LibraryItemWithPath) onSelect;

  const ChatContentDialog({super.key, required this.onSelect, required this.chatContents});

  @override
  State<ChatContentDialog> createState() => ChatContentDialogState();
}

class ChatContentDialogState extends State<ChatContentDialog> {
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController searchController = TextEditingController();

  List<LibraryItemWithPath> filterChatContents = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterContent);
    setState(() => filterChatContents = widget.chatContents);
  }

  void filterContent() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filterChatContents = widget.chatContents.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    filterChatContents.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return Dialog.fullscreen(
      child: SizedBox(
        height: size.height * 0.75,
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
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Content',
                  hintStyle: textTheme.bodyMedium,
                  prefixIcon: Icon(HugeIcons.strokeRoundedSearch01, color: colorPalette.content),
                ),
              ),
            ),
            Divider(),
            // Scrollable content
            filterChatContents.isEmpty
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
                      child: Column(
                        children: filterChatContents
                            .map<List<Widget>>(
                              (content) => [buildChatContent(context, content, widget.onSelect), const Divider()],
                            )
                            .expand((widget) => widget)
                            .toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget buildChatContent(BuildContext context, LibraryItemWithPath content, Function(LibraryItemWithPath) onSelect) {
  final ColorPalette colorPalette = AppColors().palette;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final Color color = ItemTypeStyle.getStyle(content.type).color;
  final String icon = ItemTypeStyle.getStyle(content.type).icon;

  return ListTile(
    onTap: () {
      Get.back();
      onSelect(content);
    },
    leading: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withAlpha(50), borderRadius: BorderRadius.circular(8)),
      child: CustomIcon(icon: icon, color: color, size: 24),
    ),
    title: Text(content.name, style: textTheme.titleMedium),
    subtitle: Text(content.path, style: textTheme.bodySmall),
    trailing: CustomIcon(icon: 'arrowRight', color: colorPalette.content, size: 24),
  );
}
