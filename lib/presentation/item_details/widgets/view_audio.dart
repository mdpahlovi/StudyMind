import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewAudio extends StatelessWidget {
  final LibraryItem item;
  const ViewAudio({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Audio'));
  }
}
