import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';

class CreateDocument extends StatefulWidget {
  const CreateDocument({super.key});

  @override
  State<CreateDocument> createState() => CreateDocumentState();
}

class CreateDocumentState extends State<CreateDocument> {
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

  @override
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
                  'Supported: PDF, DOC, DOCX, TXT',
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
