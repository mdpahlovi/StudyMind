import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class TypeDecoration {
  final Color color;
  final String icon;

  const TypeDecoration({required this.color, required this.icon});
}

class ItemCard extends StatelessWidget {
  final LibraryItem item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    TypeDecoration getTypeDecoration() {
      switch (item.type) {
        case ItemType.folder:
          return TypeDecoration(color: colorPalette.primary, icon: 'folder');
        case ItemType.note:
          return TypeDecoration(color: colorPalette.secondary, icon: 'note');
        case ItemType.document:
          return TypeDecoration(color: colorPalette.tertiary, icon: 'document');
        case ItemType.flashcard:
          return TypeDecoration(color: colorPalette.success, icon: 'flashcard');
        case ItemType.recording:
          return TypeDecoration(color: colorPalette.warning, icon: 'recording');
      }
    }

    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: getTypeDecoration().color.withAlpha(50),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIcon(icon: getTypeDecoration().icon, size: 16, color: getTypeDecoration().color),
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
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: CustomIcon(icon: 'menuDot', color: colorPalette.content),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: colorPalette.contentDim.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: CustomIcon(icon: getTypeDecoration().icon, size: 40)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
