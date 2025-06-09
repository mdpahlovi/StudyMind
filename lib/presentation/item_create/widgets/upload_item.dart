import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class UploadItem extends StatelessWidget {
  final void Function()? handleUpload;
  final bool isUploading;

  const UploadItem({super.key, this.handleUpload, this.isUploading = false});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: handleUpload,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: colorPalette.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorPalette.border),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isUploading) ...[
                CircularProgressIndicator(color: colorPalette.contentDim),
                const SizedBox(height: 16),
                Text('Uploading content...', textAlign: TextAlign.center, style: textTheme.bodySmall),
              ] else ...[
                Icon(Icons.cloud_upload, size: 48, color: colorPalette.contentDim),
                const SizedBox(height: 8),
                Text('Tap to select files', textAlign: TextAlign.center, style: textTheme.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
