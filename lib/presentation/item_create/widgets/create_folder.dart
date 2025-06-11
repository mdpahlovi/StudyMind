import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/constants/folder_metadata.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CreateFolder extends StatefulWidget {
  const CreateFolder({super.key});

  @override
  State<CreateFolder> createState() => CreateFolderState();
}

class CreateFolderState extends State<CreateFolder> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    itemCreateController.noteController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color Selection
        Text('Choose Color', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              FolderMetadata.color.map((color) {
                return Obx(() {
                  final selectedColor = itemCreateController.folderColor.value;

                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                      borderRadius: BorderRadius.circular(12),
                      border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                    child: InkWell(
                      onTap: () => itemCreateController.folderColor.value = color,
                      borderRadius: BorderRadius.circular(12),
                      child:
                          selectedColor == color
                              ? const Center(child: CustomIcon(icon: 'tick', color: Colors.white))
                              : const SizedBox.expand(),
                    ),
                  );
                });
              }).toList(),
        ),
        const SizedBox(height: 16),
        // Icon Selection
        Text('Choose Icon', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              FolderMetadata.icons.map((icon) {
                return Obx(() {
                  final selectedIcon = itemCreateController.folderIcon.value;

                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          selectedIcon == icon
                              ? colorPalette.primary.withAlpha(50)
                              : colorPalette.content.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          selectedIcon == icon
                              ? Border.all(color: colorPalette.primary, width: 2)
                              : Border.all(color: colorPalette.content, width: 1),
                    ),
                    child: InkWell(
                      onTap: () => itemCreateController.folderIcon.value = icon,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: CustomIcon(
                          icon: icon,
                          color: selectedIcon == icon ? colorPalette.primary : colorPalette.content,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
        ),
      ],
    );
  }
}
