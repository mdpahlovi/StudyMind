import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_options_sheet.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_badge.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/custom_icon_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemGrid extends StatelessWidget {
  final List<LibraryItem> items;
  const ItemGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final itemWidth = (size.width - 16 * 2 - 12) / 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: items.map((item) {
          return SizedBox(
            width: itemWidth,
            child: ItemCard(item: item),
          );
        }).toList(),
      ),
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
    final Color color = item.metadata?['color'] != null
        ? Color(int.parse(item.metadata!['color']!.replaceFirst('#', '0xFF')))
        : ItemTypeStyle.getStyle(item.type).color;
    final String icon = item.metadata?['icon'] ?? ItemTypeStyle.getStyle(item.type).icon;

    return Obx(() {
      final selectedItems = libraryController.selectedItems;
      final isSelected = selectedItems.contains(item);

      return Card(
        color: isSelected ? color.withAlpha(25) : colorPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected ? BorderSide(color: color.withAlpha(50), width: 1) : BorderSide.none,
        ),
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withAlpha(100), width: 1),
                      ),
                      child: CustomIcon(icon: icon, color: color, size: 20),
                    ),
                    selectedItems.isNotEmpty
                        ? CustomIconButton(
                            onTap: () => isSelected ? selectedItems.remove(item) : selectedItems.add(item),
                            child: isSelected
                                ? Icon(HugeIcons.strokeRoundedCheckmarkCircle01, size: 20)
                                : Icon(HugeIcons.strokeRoundedCircle, size: 20),
                          )
                        : CustomIconButton(
                            onTap: () => Get.bottomSheet(ItemOptionsSheet(selectedItems: [item])),
                            child: Icon(Icons.more_vert, size: 20),
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.name}\n',
                  style: textTheme.titleMedium?.copyWith(height: 1.25),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                CustomBadge(label: item.type.name, color: color),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedClock01,
                      size: 14,
                      color: colorPalette.contentDim.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Text(
                        timeago.format(item.updatedAt),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorPalette.contentDim.withValues(alpha: 0.7),
                          height: 1.25,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: colorPalette.contentDim.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '20',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorPalette.contentDim,
                          height: 1.25,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
