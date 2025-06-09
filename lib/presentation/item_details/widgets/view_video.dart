import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewVideo extends StatelessWidget {
  final LibraryItem item;
  const ViewVideo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Video'));
  }
}
