import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemFolder {
  final int? id;
  final String name;
  final String path;

  ItemFolder({this.id, required this.name, required this.path});
}

class ParentFolderSelector extends StatelessWidget {
  final List<ItemFolder> folders;
  final int? value;
  final Function(int?) onChanged;

  const ParentFolderSelector({super.key, required this.folders, this.value, required this.onChanged});

  Widget buildFolderSelectorSheet(BuildContext context) {
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
              itemCount: folders.length,
              itemBuilder: (context, index) {
                final folder = folders[index];
                final isSelected = value == folder.id;
                final isRoot = folder.id == null;
                return ListTile(
                  onTap: () {
                    onChanged(folder.id);
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
            ),
          ),
        ],
      ),
    );
  }

  ItemFolder getSelectedFolder() {
    return folders.firstWhere(
      (folder) => folder.id == value,
      orElse: () => folders.isNotEmpty ? folders[0] : ItemFolder(id: null, name: 'Root Folder', path: '/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final selectedFolder = getSelectedFolder();
    final isRoot = selectedFolder.id == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parent Folder', style: textTheme.labelLarge),
        SizedBox(height: 8),
        InkWell(
          onTap: () => Get.bottomSheet(buildFolderSelectorSheet(context)),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorPalette.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorPalette.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
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
                      Text(selectedFolder.name, style: textTheme.titleMedium),
                      Text(isRoot ? 'Main directory' : selectedFolder.path, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                CustomIcon(icon: 'arrowDown', color: colorPalette.content, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
