import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewNote extends StatelessWidget {
  final LibraryItem item;
  const ViewNote({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Note'));
  }
}
