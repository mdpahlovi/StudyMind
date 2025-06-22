import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class RenameDialog extends StatefulWidget {
  final String value;
  final void Function(String value)? onConfirm;
  const RenameDialog({super.key, required this.value, this.onConfirm});

  @override
  State<RenameDialog> createState() => RenameDialogState();
}

class RenameDialogState extends State<RenameDialog> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();
  String value = '';

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter Name', style: textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextFormField(initialValue: widget.value, onChanged: (val) => setState(() => value = val)),
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
                  onPressed: value.isNotEmpty && widget.value != value
                      ? () {
                          Get.back();
                          if (widget.onConfirm != null) widget.onConfirm!(value);
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
