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
    final EdgeInsets paddings = MediaQuery.of(context).viewInsets;

    return Container(
      decoration: BoxDecoration(
        color: colorPalette.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CustomIcon(icon: typeStyle.icon, size: 24),
                const SizedBox(width: 6),
                Text(widget.item.name, style: textTheme.headlineMedium),
              ],
            ),
          ),
          Divider(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: paddings.bottom),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text('What is this?', style: textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text(
                    'This is a ${widget.item.type.toString().split('.').last.toUpperCase()} item',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
