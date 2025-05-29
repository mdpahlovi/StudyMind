import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const CustomIcon(icon: 'arrowLeft', size: 28), onPressed: onPressed ?? () => Get.back());
  }
}
