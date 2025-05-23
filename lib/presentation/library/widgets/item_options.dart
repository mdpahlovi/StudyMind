import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/presentation/library/widgets/item_type_style.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class ItemOptions extends StatefulWidget {
  final LibraryItem item;
  const ItemOptions({super.key, required this.item});

  @override
  State<ItemOptions> createState() => ItemOptionsState();
}

class ItemOptionsState extends State<ItemOptions> {
  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TypeStyle typeStyle = ItemTypeStyle(type: widget.item.type).decoration;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIcon(icon: typeStyle.icon, size: 24),
              const SizedBox(width: 6),
              Text(widget.item.name, style: textTheme.titleMedium),
            ],
          ),
          Expanded(child: Center(child: Text('What is this?', style: textTheme.bodySmall))),
        ],
      ),
    );
  }
}
