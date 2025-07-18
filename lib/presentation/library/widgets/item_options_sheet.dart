import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/services/download.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:studymind/widgets/dialog/move.dart';
import 'package:studymind/widgets/dialog/rename.dart';

class ItemOption {
  void Function()? onTap;
  final IconData icon;
  final String title;
  final bool danger;
  final bool hide;
  final bool isLoading;

  ItemOption({
    required this.icon,
    required this.title,
    this.danger = false,
    this.hide = false,
    this.onTap,
    this.isLoading = false,
  });
}

class ItemOptionsSheet extends StatefulWidget {
  final List<LibraryItem> selectedItems;
  const ItemOptionsSheet({super.key, this.selectedItems = const []});

  @override
  State<ItemOptionsSheet> createState() => ItemOptionsSheetState();
}

class ItemOptionsSheetState extends State<ItemOptionsSheet> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final List<LibraryItem> selectedItems = widget.selectedItems;

    final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TypeStyle typeStyle = ItemTypeStyle.getStyle(selectedItems.first.type);
    final EdgeInsets paddings = MediaQuery.of(context).padding;
    final bool isInSameFolder = selectedItems.every((item) => item.parentId == selectedItems.first.parentId);

    final List<ItemOption> options = [
      ItemOption(
        onTap: () async {
          Get.dialog(
            ConfirmDialog(
              message: 'You want to make it mentionable? This enables it to mentionable in\nai chat.',
              onConfirm: () => itemCreateController.updateLibraryItem(selectedItems.first.uid, isEmbedded: true),
            ),
          );
        },
        title: 'Mentionable',
        icon: HugeIcons.strokeRoundedAiContentGenerator01,
        hide:
            selectedItems.length != 1 ||
            selectedItems.first.metadata?['filePath'] == null ||
            selectedItems.first.type != ItemType.document ||
            selectedItems.first.isEmbedded,
        isLoading: isDownloading,
      ),
      ItemOption(
        onTap: () async {
          Get.back();
          setState(() => isDownloading = true);
          await Download.fromSupabase(selectedItems.first.metadata!['filePath']);
          setState(() => isDownloading = false);
        },
        title: 'Download',
        icon: HugeIcons.strokeRoundedDownload01,
        hide: selectedItems.length != 1 || selectedItems.first.metadata?['filePath'] == null,
      ),
      ItemOption(
        onTap: () {
          Get.dialog(
            RenameDialog(
              value: selectedItems.first.name,
              onConfirm: (name) {
                itemCreateController.updateLibraryItem(selectedItems.first.uid, name: name);
              },
            ),
          );
        },
        title: 'Rename',
        icon: HugeIcons.strokeRoundedEdit02,
        hide: selectedItems.length != 1,
      ),
      ItemOption(
        onTap: () => Get.dialog(MoveDialog(items: selectedItems)),
        title: 'Move',
        icon: HugeIcons.strokeRoundedFolderExport,
        hide: !isInSameFolder,
      ),
      ItemOption(
        onTap: () {
          Get.dialog(
            ConfirmDialog(
              message: 'You want to remove? If yes,\nPlease press confirm.',
              onConfirm: () => itemCreateController.updateBulkLibraryItem(selectedItems, 'REMOVE'),
            ),
          );
        },
        title: 'Remove',
        icon: HugeIcons.strokeRoundedDelete02,
        danger: true,
        hide: selectedItems.isEmpty,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fixed header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (selectedItems.length == 1) CustomIcon(icon: typeStyle.icon, size: 24),
                if (selectedItems.length == 1) const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    selectedItems.length == 1 ? selectedItems.first.name : '${selectedItems.length} items selected',
                    style: textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: paddings.bottom),
              child: Column(
                children: options
                    .where((option) => !option.hide)
                    .map<List<Widget>>((option) => [buildOptionTile(context, option), const Divider()])
                    .expand((widget) => widget)
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildOptionTile(BuildContext context, ItemOption option) {
  final ColorPalette colorPalette = AppColors().palette;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final Color color = option.danger ? colorPalette.error : colorPalette.content;

  return ListTile(
    onTap: option.isLoading ? null : option.onTap,
    leading: Icon(option.icon, color: color, size: 20),
    title: Text(option.title, style: textTheme.titleMedium?.copyWith(color: color)),
    trailing: option.isLoading
        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: color))
        : null,
  );
}
