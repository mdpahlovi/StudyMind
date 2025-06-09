import 'package:flutter/material.dart';
import 'package:studymind/controllers/library.dart';

class ViewDocument extends StatelessWidget {
  final LibraryItem item;
  const ViewDocument({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('View Document'));
  }
}
