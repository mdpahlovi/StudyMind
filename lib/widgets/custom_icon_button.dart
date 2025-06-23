import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;

  const CustomIconButton({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: InkWell(borderRadius: BorderRadius.circular(14), onTap: onTap, child: child),
    );
  }
}
