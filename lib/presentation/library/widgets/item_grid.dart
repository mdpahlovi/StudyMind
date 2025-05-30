import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_options_sheet.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemGrid extends StatelessWidget {
  final List<LibraryItem> items;
  const ItemGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => ItemCard(item: items[index]),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final LibraryItem item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final LibraryController libraryController = Get.find<LibraryController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TypeStyle typeStyle = ItemTypeStyle.getStyle(item.type);

    return Obx(() {
      final selectedItems = libraryController.selectedItems;
      final isSelected = selectedItems.contains(item);

      return Card(
        color: isSelected ? colorPalette.content.withAlpha(26) : colorPalette.surface,
        child: InkWell(
          onTap: () {
            if (selectedItems.isEmpty) {
              libraryController.navigateToItem(item);
            } else {
              isSelected ? selectedItems.remove(item) : selectedItems.add(item);
            }
          },
          onLongPress: () => isSelected ? selectedItems.remove(item) : selectedItems.add(item),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: typeStyle.color.withAlpha(50),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIcon(icon: typeStyle.icon, size: 16, color: typeStyle.color),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.name,
                        style: textTheme.labelMedium?.copyWith(height: 1.25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    selectedItems.isNotEmpty
                        ? Container(
                          margin: const EdgeInsets.all(6),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: colorPalette.content),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => isSelected ? selectedItems.remove(item) : selectedItems.add(item),
                            child: isSelected ? const CustomIcon(icon: 'tick', size: 16) : const SizedBox(),
                          ),
                        )
                        : // Three dot menu button
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => Get.bottomSheet(ItemOptionsSheet(item: item)),
                            child: const Icon(Icons.more_vert),
                          ),
                        ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorPalette.contentDim.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: CustomIcon(icon: typeStyle.icon, size: 40)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
