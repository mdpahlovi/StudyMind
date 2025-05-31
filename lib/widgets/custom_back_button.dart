import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomBackButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onPressed;
  const CustomBackButton({super.key, this.icon = 'arrowLeft', this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(child: IconButton(icon: CustomIcon(icon: icon, size: 28), onPressed: onPressed ?? () => Get.back()));
  }
}
