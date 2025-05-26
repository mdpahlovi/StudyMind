import 'package:flutter/material.dart';
import 'package:studymind/widgets/custom_icon.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const CustomIcon(icon: 'notification'));
  }
}
