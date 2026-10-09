import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/constants/item_type.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/controllers/removed_item.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_back_button.dart';
import 'package:studymind/widgets/custom_icon.dart';
import 'package:studymind/widgets/dialog/confirm.dart';
import 'package:timeago/timeago.dart' as timeago;

class RemovedItemScreen extends StatelessWidget {
  const RemovedItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemovedItemController controller = Get.find<RemovedItemController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        controller.selectedItems.isEmpty ? Get.back() : controller.selectedItems.clear();
      },
      child: RefreshIndicator(
        onRefresh: () async => controller.fetchRemovedItems(),
        child: Scaffold(
          appBar: AppBar(
            leading: Obx(() {
              if (controller.selectedItems.isEmpty) return const CustomBackButton();

              return IconButton(
                icon: const CustomIcon(icon: 'cancel', size: 28),
                onPressed: () => controller.selectedItems.clear(),
              );
            }),
            title: Obx(() {
              final selectedItems = controller.selectedItems;
              return Text(selectedItems.isEmpty ? 'Removed Items' : '${selectedItems.length}  items');
            }),
            actions: [
              Obx(() {
                final selectedItems = controller.selectedItems;

                if (selectedItems.isEmpty) return const SizedBox.shrink();

                final allSelected = controller.removedItems.isNotEmpty && selectedItems.length == controller.removedItems.length;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: allSelected ? 'Deselect all' : 'Select all',
                      icon: Icon(allSelected ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedCircle, size: 22),
                      onPressed: controller.selectAll,
                    ),
                    IconButton(
                      tooltip: 'Restore',
                      icon: const Icon(HugeIcons.strokeRoundedRestoreBin, size: 22),
                      onPressed: controller.restoreSelected,
                    ),
                    IconButton(
                      tooltip: 'Delete permanently',
                      icon: Icon(HugeIcons.strokeRoundedDelete02, size: 22, color: colorPalette.error),
                      onPressed: () => Get.dialog(
                        ConfirmDialog(
                          message: 'Selected items will be deleted permanently.\nThis cannot be undone.',
                          onConfirm: controller.deleteSelected,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<LibraryItem> removedItems = controller.removedItems;

            if (removedItems.isEmpty) return buildEmptyState(colorPalette, textTheme);

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: removedItems.length,
              itemBuilder: (context, index) =>
                  RemovedItemTile(item: removedItems[index], onTap: () => controller.toggleSelection(removedItems[index])),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
            );
          }),
        ),
      ),
    );
  }

  Widget buildEmptyState(ColorPalette colorPalette, TextTheme textTheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 64),
        Icon(HugeIcons.strokeRoundedDelete02, size: 64, color: colorPalette.contentDim),
        const SizedBox(height: 16),
        Text('No removed items', textAlign: TextAlign.center, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Items you remove from your library will appear here.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: colorPalette.contentDim),
        ),
      ],
    );
  }
}

class RemovedItemTile extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback onTap;

  const RemovedItemTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final RemovedItemController controller = Get.find<RemovedItemController>();
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final TypeStyle typeStyle = ItemTypeStyle.getStyle(item.type);
    final Color color = item.metadata?['color'] != null
        ? Color(int.parse(item.metadata!['color']!.replaceFirst('#', '0xFF')))
        : typeStyle.color;
    final String icon = item.metadata?['icon'] ?? typeStyle.icon;

    return Obx(() {
      final bool selected = controller.selectedItems.contains(item);

      return Card(
        color: selected ? color.withAlpha(25) : colorPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: selected ? BorderSide(color: color.withAlpha(50), width: 1) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withAlpha(50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withAlpha(100), width: 1),
                  ),
                  child: CustomIcon(icon: icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        '${item.type.name} • removed ${timeago.format(item.updatedAt)}',
                        style: textTheme.bodySmall?.copyWith(color: colorPalette.contentDim),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  selected ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedCircle,
                  size: 22,
                  color: selected ? colorPalette.primary : colorPalette.contentDim,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
