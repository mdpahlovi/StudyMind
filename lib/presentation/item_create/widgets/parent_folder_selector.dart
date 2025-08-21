import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ParentFolderSelector extends StatefulWidget {
  const ParentFolderSelector({super.key});

  @override
  State<ParentFolderSelector> createState() => ParentFolderSelectorState();
}

class ParentFolderSelectorState extends State<ParentFolderSelector> {
  final LibraryController libraryController = Get.find<LibraryController>();
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  Widget buildFolderSelectorSheet(BuildContext context, List<LibraryItemWithPath> folders) {
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
            child: ListView.separated(
              itemCount: folders.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = libraryController.selectedFolder.value?.id == null;

                  return ListTile(
                    onTap: () {
                      libraryController.selectedFolder.value = null;
                      Get.back();
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: colorPalette.primary.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                      child: CustomIcon(icon: 'home', color: colorPalette.primary),
                    ),
                    title: Text('Root Folder', style: textTheme.titleMedium),
                    subtitle: Text('./', style: textTheme.bodySmall),
                    trailing: isSelected ? CustomIcon(icon: 'tickCircle', color: colorPalette.primary) : null,
                  );
                } else {
                  final folder = folders[index - 1];
                  final isSelected = libraryController.selectedFolder.value?.id == folder.id;

                  return ListTile(
                    onTap: () {
                      libraryController.selectedFolder.value = folder;
                      Get.back();
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: colorPalette.content.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                      child: CustomIcon(icon: 'folder', color: colorPalette.content),
                    ),
                    title: Text(folder.name, style: textTheme.titleMedium),
                    subtitle: Text(folder.path, style: textTheme.bodySmall),
                    trailing: isSelected ? CustomIcon(icon: 'tickCircle', color: colorPalette.primary) : null,
                  );
                }
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorPalette.border),
      ),
      child: InkWell(
        onTap: () => Get.bottomSheet(buildFolderSelectorSheet(context, flatFolder(libraryController.libraryItemsWithPath))),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Obx(() {
            final folder = libraryController.selectedFolder.value;
            final isRoot = folder?.id == null;

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isRoot ? colorPalette.primary.withAlpha(50) : colorPalette.content.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIcon(icon: isRoot ? 'home' : 'folder', color: isRoot ? colorPalette.primary : colorPalette.content),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(folder?.name ?? 'Root Folder', style: textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                      Text(folder?.path ?? './', style: textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                CustomIcon(icon: 'arrowDown', color: colorPalette.content, size: 24),
              ],
            );
          }),
        ),
      ),
    );
  }
}

List<LibraryItemWithPath> flatFolder(List<LibraryItemWithPath> items) {
  List<LibraryItemWithPath> flatList = [];

  void flatRecursively(List<LibraryItemWithPath> currentItems) {
    for (LibraryItemWithPath item in currentItems) {
      if (item.type == ItemType.folder) {
        flatList.add(item);
        if (item.children.isNotEmpty) flatRecursively(item.children);
      }
    }
  }

  flatRecursively(items);
  return flatList;
}
