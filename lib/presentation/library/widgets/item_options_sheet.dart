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
  final bool disabled;
  final bool isLoading;

  ItemOption({
    required this.icon,
    required this.title,
    this.danger = false,
    this.disabled = false,
    this.onTap,
    this.isLoading = false,
  });
}

class ItemOptionsSheet extends StatefulWidget {
  final LibraryItem? item;
  const ItemOptionsSheet({super.key, this.item});

  @override
  State<ItemOptionsSheet> createState() => ItemOptionsSheetState();
}

class ItemOptionsSheetState extends State<ItemOptionsSheet> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    if (widget.item != null) {
      return buildItemOptionsContainer(
        context: context,
        selectedItems: [widget.item!],
        isDownloading: isDownloading,
        onDownloadStateChanged: (loading) => setState(() => isDownloading = loading),
      );
    } else {
      return Obx(
        () => buildItemOptionsContainer(
          context: context,
          selectedItems: libraryController.selectedItems,
          isDownloading: isDownloading,
          onDownloadStateChanged: (loading) => setState(() => isDownloading = loading),
        ),
      );
    }
  }
}

Widget buildItemOptionsContainer({
  required BuildContext context,
  required List<LibraryItem> selectedItems,
  required bool isDownloading,
  required Function(bool) onDownloadStateChanged,
}) {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  final ColorPalette colorPalette = AppColors().palette;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final TypeStyle typeStyle = ItemTypeStyle.getStyle(selectedItems.first.type);
  final EdgeInsets paddings = MediaQuery.of(context).padding;

  final List<ItemOption> options = [
    ItemOption(
      onTap: selectedItems.first.metadata?['filePath'] != null && !isDownloading
          ? () async {
              Get.back();
              onDownloadStateChanged(true);
              await Download.fromSupabase(selectedItems.first.metadata!['filePath']);
              onDownloadStateChanged(false);
            }
          : null,
      title: 'Download',
      icon: HugeIcons.strokeRoundedDownload01,
      disabled:
          selectedItems.length > 1 ||
          selectedItems.first.type == ItemType.folder ||
          selectedItems.first.type == ItemType.note ||
          selectedItems.first.type == ItemType.flashcard,
      isLoading: isDownloading,
    ),
    ItemOption(
      onTap: () => Get.dialog(RenameDialog(item: selectedItems.first)),
      title: 'Rename',
      icon: HugeIcons.strokeRoundedEdit02,
      disabled: selectedItems.length > 1,
    ),
    ItemOption(
      onTap: () => Get.dialog(MoveDialog(items: selectedItems)),
      title: 'Move',
      icon: HugeIcons.strokeRoundedFolderExport,
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
                  .where((option) => !option.disabled)
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
