import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CreateFolder extends StatelessWidget {
  const CreateFolder({super.key});

  static List<String> folderColors = [
    '#A8C686',
    '#2196F3',
    '#4CAF50',
    '#FF9800',
    '#9C27B0',
    '#F44336',
    '#009688',
    '#3F51B5',
    '#E91E63',
    '#FFCDD2',
  ];

  static List<String> folderIcons = [
    'folder',
    'book',
    'physics',
    'chemistry',
    'math',
    'history',
    'artificialIntelligence',
    'statistics',
    'botany',
    'factory',
  ];

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
              folderColors.map((color) {
                return GestureDetector(
                  onTap: () => itemCreateController.folderColor.value = color,
                  child: Obx(() {
                    final selectedColor = itemCreateController.folderColor.value;

                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(12),
                        border: selectedColor == color ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                      child: selectedColor == color ? const CustomIcon(icon: 'tick', color: Colors.white) : null,
                    );
                  }),
                );
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
              folderIcons.map((icon) {
                return GestureDetector(
                  onTap: () => itemCreateController.folderIcon.value = icon,
                  child: Obx(() {
                    final selectedIcon = itemCreateController.folderIcon.value;

                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            selectedIcon == icon
                                ? colorPalette.primary.withAlpha(50)
                                : colorPalette.content.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            selectedIcon == icon
                                ? Border.all(color: colorPalette.primary, width: 2)
                                : Border.all(color: colorPalette.content, width: 1),
                      ),
                      child: CustomIcon(
                        icon: icon,
                        color: selectedIcon == icon ? colorPalette.primary : colorPalette.content,
                        size: 24,
                      ),
                    );
                  }),
                );
              }).toList(),
        ),
      ],
    );
  }
}
