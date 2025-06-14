import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/theme/colors.dart';

class RenameDialog extends StatefulWidget {
  final LibraryItem item;
  const RenameDialog({super.key, required this.item});

  @override
  State<RenameDialog> createState() => RenameDialogState();
}

class RenameDialogState extends State<RenameDialog> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter Name', style: textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextFormField(initialValue: widget.item.name, onChanged: (value) => setState(() => name = value)),
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
                ElevatedButton(
                  onPressed: name.isNotEmpty && widget.item.name != name
                      ? () {
                          Get.back();
                          itemCreateController.updateLibraryItem(widget.item.uid, name);
                        }
                      : null,
                  child: Text('Rename', style: textTheme.titleMedium),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
