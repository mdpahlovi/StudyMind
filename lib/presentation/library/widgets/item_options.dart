import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_type_style.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemOptions extends StatefulWidget {
  final LibraryItem? item;
  const ItemOptions({super.key, this.item});

  @override
  State<ItemOptions> createState() => ItemOptionsState();
}

class ItemOptionsState extends State<ItemOptions> {
  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final EdgeInsets paddings = MediaQuery.of(context).viewInsets;

    return Obx(() {
      final selectedItems = widget.item != null ? [widget.item!] : libraryController.selectedItems;
      final TypeStyle typeStyle = ItemTypeStyle(type: selectedItems.first.type).decoration;

      return Container(
        decoration: BoxDecoration(
          color: colorPalette.background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CustomIcon(icon: typeStyle.icon, size: 24),
                  const SizedBox(width: 6),
                  selectedItems.length == 1
                      ? Text(selectedItems.first.name, style: textTheme.headlineMedium)
                      : Text('${selectedItems.length} items selected', style: textTheme.headlineMedium),
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
    });
  }
}
