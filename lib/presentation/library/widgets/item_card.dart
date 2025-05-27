import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_options.dart';
import 'package:studymind/presentation/library/widgets/item_type_style.dart';
import 'package:studymind/routes/routes.dart' show AppRoutes;
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemCard extends StatefulWidget {
  final LibraryItem item;
  const ItemCard({super.key, required this.item});

  @override
  State<ItemCard> createState() => ItemCardState();
}

class ItemCardState extends State<ItemCard> {
  final LibraryController libraryController = Get.put(LibraryController());

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TypeStyle typeStyle = ItemTypeStyle(type: widget.item.type).decoration;

    return Card(
      child: InkWell(
        onTap: () {
          switch (widget.item.type) {
            case ItemType.folder:
              libraryController.loadFolderData(widget.item.id);
              Get.toNamed(AppRoutes.library.replaceFirst(':id', widget.item.id.toString()));
              break;
            default:
              Get.snackbar(
                'Work in progress',
                "Item type '${widget.item.type.toString().split('.').last.toUpperCase()}' is not supported",
              );
              break;
          }
        },
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
                      color: typeStyle.color.withAlpha(50),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIcon(icon: typeStyle.icon, size: 16, color: typeStyle.color),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.item.name,
                      style: textTheme.labelMedium?.copyWith(height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Get.bottomSheet(ItemOptions(item: widget.item)),
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
  }
}
