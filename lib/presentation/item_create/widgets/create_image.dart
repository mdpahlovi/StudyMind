import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:studymind/controllers/item_create.dart';
import 'package:studymind/theme/colors.dart';

class CreateImage extends StatefulWidget {
  const CreateImage({super.key});

  @override
  State<CreateImage> createState() => CreateImageState();
}

class CreateImageState extends State<CreateImage> {
  final ItemCreateController itemCreateController = Get.find<ItemCreateController>();

  Future<void> handleUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      allowMultiple: false,
      withData: false, // Set to true if you need file data immediately
      withReadStream: false,
    );

    if (result != null && result.files.isNotEmpty) {
      itemCreateController.selectedFile.value = result.files.first;
    }
  }

  void removeFile() {
    if (itemCreateController.selectedFile.value != null) {
      itemCreateController.selectedFile.value = null;
    }
  }

  @override
  void dispose() {
    itemCreateController.selectedFile.value = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Image', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        // Upload Area
        SizedBox(
          height: 160,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorPalette.border),
            ),
            child: InkWell(
              onTap: handleUpload,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(HugeIcons.strokeRoundedUpload03, size: 48, color: colorPalette.contentDim),
                    ),
                    const SizedBox(height: 8),
                    Text('Tap to select file', textAlign: TextAlign.center, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Selected File Display
        Obx(() {
          final selectedFile = itemCreateController.selectedFile.value;

          if (selectedFile == null) {
            return const SizedBox.shrink();
          } else {
            return Container(
              padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: colorPalette.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorPalette.border),
              ),
              child: Row(
                children: [
                  Icon(getFileIcon(selectedFile.extension ?? ''), color: colorPalette.contentDim),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedFile.name, style: textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                        Text('${(selectedFile.size / 1024).toStringAsFixed(1)} KB', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: removeFile,
                    icon: Icon(Icons.close, size: 20, color: colorPalette.contentDim),
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                ],
              ),
            );
          }
        }),
        Obx(() {
          final selectedFile = itemCreateController.selectedFile.value;

          if (selectedFile == null) {
            return const SizedBox.shrink();
          } else {
            return const SizedBox(height: 16);
          }
        }),
        // Supported formats
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colorPalette.warning.withAlpha(50), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: colorPalette.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Supported: JPG, JPEG, PNG, GIF',
                  style: TextStyle(fontSize: 12, color: colorPalette.warning),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return HugeIcons.strokeRoundedJpg02;
      case 'png':
        return HugeIcons.strokeRoundedPng02;
      case 'gif':
        return HugeIcons.strokeRoundedGif02;
      default:
        return HugeIcons.strokeRoundedJpg02;
    }
  }
}
