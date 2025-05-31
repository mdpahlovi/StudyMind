import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class CreateImage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CreateImage({super.key, required this.formKey});

  @override
  State<CreateImage> createState() => CreateImageState();
}

class CreateImageState extends State<CreateImage> {
  String uploadMethod = 'file';
  bool isUploading = false;

  void handleUpload() {
    setState(() => isUploading = true);
    // Simulate upload delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => isUploading = false);
      }
    });
  }

  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Document', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        // Upload Area
        GestureDetector(
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
                    Text(
                      'Uploading document...\nPlease wait a moment',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  ] else ...[
                    Icon(
                      uploadMethod == 'file' ? Icons.cloud_upload : Icons.camera_alt,
                      size: 48,
                      color: colorPalette.contentDim,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      uploadMethod == 'file'
                          ? 'Tap to select files\nPDF, DOC, DOCX, TXT'
                          : 'Tap to scan document\nAuto-detect text with OCR',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Supported formats
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: colorPalette.warning.withAlpha(50), borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: colorPalette.warning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  uploadMethod == 'file'
                      ? 'Supported: PDF, Word documents, PowerPoint, and text files'
                      : 'AI-powered text recognition for handwritten and printed documents',
                  style: TextStyle(fontSize: 12, color: colorPalette.warning),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
