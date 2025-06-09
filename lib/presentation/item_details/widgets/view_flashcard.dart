import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewFlashcard extends StatelessWidget {
  final LibraryItem item;
  const ViewFlashcard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Flashcard'));
  }
}
