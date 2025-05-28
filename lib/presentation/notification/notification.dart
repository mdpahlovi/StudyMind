import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/widgets/custom_icon.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const CustomIcon(icon: 'arrowLeft', size: 28), onPressed: () => Get.back()),
        title: const Text('Notification'),
      ),
      body: const Center(child: Text('Notification')),
    );
  }
}
