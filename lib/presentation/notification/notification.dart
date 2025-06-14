import 'package:flutter/material.dart';
import 'package:studymind/widgets/custom_back_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: CustomBackButton(), title: const Text('Notification')),
      body: const Center(child: Text('Opps! No notification available.')),
    );
  }
}
