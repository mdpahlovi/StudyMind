import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String? prefixIcon;
  final String? suffixIcon;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: colorPalette.content, strokeWidth: 2),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[CustomIcon(icon: prefixIcon!), const SizedBox(width: 8)],
                    Text(text, style: textTheme.titleMedium),
                    if (suffixIcon != null) ...[const SizedBox(width: 8), CustomIcon(icon: suffixIcon!)],
                  ],
                ),
      ),
    );
  }
}
