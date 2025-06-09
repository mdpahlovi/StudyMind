import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewImage extends StatelessWidget {
  final LibraryItem item;
  const ViewImage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Image'));
  }
}
