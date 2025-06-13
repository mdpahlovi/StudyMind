import 'dart:math';

import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';
import 'package:studymind/widgets/custom_image.dart';

class ViewImage extends StatelessWidget {
  final LibraryItem item;
  const ViewImage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 32;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomImage(imageUrl: item.metadata?['fileUrl'] ?? '', width: width, height: width * sqrt(2)),
    );
  }
}
