import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/routes/routes.dart';
import 'package:studymind/widgets/custom_icon.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.toNamed(AppRoutes.notification),
      icon: const CustomIcon(icon: 'notification'),
    );
  }
}
