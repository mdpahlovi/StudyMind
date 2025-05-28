import 'package:flutter/material.dart';
import 'package:studymind/widgets/notification_button.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Community'), actions: [NotificationButton()]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome to StudyMind Community', style: textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Connect with fellow learners and share your knowledge. Join our community to get started!',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: Text('Join Discussion', style: textTheme.titleMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
