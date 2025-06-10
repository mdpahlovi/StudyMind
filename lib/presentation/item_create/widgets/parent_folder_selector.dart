import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ParentFolderSelector extends StatelessWidget {
  const ParentFolderSelector({super.key});

  Widget buildFolderSelectorSheet(BuildContext context) {
    final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

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
                Text("Select Parent Folder", style: textTheme.headlineMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: CustomIcon(icon: 'cancel', color: colorPalette.content, size: 24),
                ),
              ],
            ),
          ),
          Divider(),
          // Folder list
          Expanded(
            child: Obx(() {
              final List<Folder> folders = itemCreateController.folders;

              if (itemCreateController.isLoadingFolder.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator(), const SizedBox(height: 16), Text('Fetching folders...')],
                  ),
                );
              }

              if (folders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(HugeIcons.strokeRoundedSadDizzy, size: 44),
                      const SizedBox(height: 16),
                      Text('No other folders found'),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  final isSelected = itemCreateController.selectedFolder.value?.id == folder.id;
                  final isRoot = folder.id == null;
                  return ListTile(
                    onTap: () {
                      itemCreateController.selectedFolder.value = folder;
                      Get.back();
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRoot ? colorPalette.primary.withAlpha(50) : colorPalette.content.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIcon(
                        icon: isRoot ? 'home' : 'folder',
                        color: isRoot ? colorPalette.primary : colorPalette.content,
                      ),
                    ),
                    title: Text(folder.name, style: textTheme.titleMedium),
                    subtitle: Text(isRoot ? 'Main directory' : folder.path, style: textTheme.bodySmall),
                    trailing: isSelected ? CustomIcon(icon: 'tickCircle', color: colorPalette.primary) : null,
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parent Folder', style: textTheme.labelLarge),
        SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorPalette.border),
          ),
          child: InkWell(
            onTap: () => Get.bottomSheet(buildFolderSelectorSheet(context)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Obx(() {
                final folder = itemCreateController.selectedFolder.value;
                final isRoot = folder?.id == null;

                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRoot ? colorPalette.primary.withAlpha(50) : colorPalette.content.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIcon(
                        icon: isRoot ? 'home' : 'folder',
                        color: isRoot ? colorPalette.primary : colorPalette.content,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(folder?.name ?? 'Root Folder', style: textTheme.titleMedium),
                          Text(isRoot ? 'Main directory' : folder?.path ?? '/', style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    CustomIcon(icon: 'arrowDown', color: colorPalette.content, size: 24),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
