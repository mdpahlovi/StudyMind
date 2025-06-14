import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/item_create/widgets/parent_folder_selector.dart';
import 'package:studymind/theme/colors.dart';

class MoveDialog extends StatefulWidget {
  final List<LibraryItem> items;
  const MoveDialog({super.key, required this.items});

  @override
  State<MoveDialog> createState() => MoveDialogState();
}

class MoveDialogState extends State<MoveDialog> {
  final LibraryController libraryController = Get.find<LibraryController>();
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: colorPalette.surface, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Parent Folder', style: textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ParentFolderSelector(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: colorPalette.content),
                  child: Text('Cancel', style: textTheme.titleMedium?.copyWith(color: colorPalette.background)),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final currentFolder = libraryController.breadcrumbs.isNotEmpty
                      ? libraryController.breadcrumbs.last.uid
                      : null;
                  final selectedFolder = itemCreateController.selectedFolder.value?.uid;

                  return ElevatedButton(
                    onPressed: currentFolder != selectedFolder
                        ? () {
                            Get.back();
                            itemCreateController.updateBulkLibraryItem(widget.items, 'MOVE');
                          }
                        : null,
                    child: Text('Move', style: textTheme.titleMedium),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
