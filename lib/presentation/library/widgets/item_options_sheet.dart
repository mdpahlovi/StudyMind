import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';

class ItemOption {
  void Function()? onTap;
  final IconData icon;
  final String title;
  final bool danger;
  final bool disabled;

  ItemOption({required this.icon, required this.title, this.danger = false, this.disabled = false, this.onTap});
}

class ItemOptionsSheet extends StatefulWidget {
  final LibraryItem? item;
  const ItemOptionsSheet({super.key, this.item});

  @override
  State<ItemOptionsSheet> createState() => ItemOptionsSheetState();
}

class ItemOptionsSheetState extends State<ItemOptionsSheet> {
  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    if (widget.item != null) {
      return buildItemOptionsContainer(context: context, selectedItems: [widget.item!]);
    } else {
      return Obx(() => buildItemOptionsContainer(context: context, selectedItems: libraryController.selectedItems));
    }
  }
}

Widget buildItemOptionsContainer({required BuildContext context, required List<LibraryItem> selectedItems}) {
  final ColorPalette colorPalette = AppColors().palette;
  final TextTheme textTheme = Theme.of(context).textTheme;
  final TypeStyle typeStyle = ItemTypeStyle.getStyle(selectedItems.first.type);
  final EdgeInsets paddings = MediaQuery.of(context).padding;

  final List<ItemOption> options = [
    ItemOption(
      title: 'Download',
      icon: HugeIcons.strokeRoundedDownload01,
      disabled:
          selectedItems.length > 1 ||
          selectedItems.first.type == ItemType.folder ||
          selectedItems.first.type == ItemType.note ||
          selectedItems.first.type == ItemType.flashcard,
    ),
    ItemOption(title: 'Rename', icon: HugeIcons.strokeRoundedEdit02, disabled: selectedItems.length > 1),
    ItemOption(title: 'Move', icon: HugeIcons.strokeRoundedFolderExport),
    ItemOption(
      onTap: () {
        Get.dialog(ConfirmDialog(message: 'You want to remove? If yes,\nPlease press confirm.'));
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
              Text(
                selectedItems.length == 1 ? selectedItems.first.name : '${selectedItems.length} items selected',
                style: textTheme.headlineMedium,
              ),
              const Spacer(),
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

  return ListTile(
    onTap: option.onTap,
    leading: Icon(option.icon, color: option.danger ? colorPalette.error : colorPalette.content, size: 20),
    title: Text(
      option.title,
      style: textTheme.titleMedium?.copyWith(color: option.danger ? colorPalette.error : colorPalette.content),
    ),
  );
}
