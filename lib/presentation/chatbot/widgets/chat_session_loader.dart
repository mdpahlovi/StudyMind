import 'package:flutter/material.dart';
import 'package:studymind/presentation/home/widgets/recent_loader.dart';

class ChatSessionLoader extends StatelessWidget {
  const ChatSessionLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) => RecentLoader(),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
