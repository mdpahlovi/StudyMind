import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to StudyMind Community',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Connect with fellow learners and share your knowledge', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: () {}, child: const Text('Join Discussion')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
