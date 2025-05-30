import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

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
  final EdgeInsets paddings = MediaQuery.of(context).viewInsets;

  return Container(
    decoration: BoxDecoration(
      color: colorPalette.background,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              selectedItems.length == 1 ? CustomIcon(icon: typeStyle.icon, size: 24) : SizedBox(),
              selectedItems.length == 1 ? SizedBox(width: 6) : SizedBox(),
              selectedItems.length == 1
                  ? Text(selectedItems.first.name, style: textTheme.headlineMedium)
                  : Text('${selectedItems.length} items selected', style: textTheme.headlineMedium),
              const Spacer(),
              IconButton(
                onPressed: () => Get.back(),
                icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
              ),
            ],
          ),
        ),
        Divider(),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: paddings.bottom),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text('Currently working on this feature', style: textTheme.titleMedium),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
