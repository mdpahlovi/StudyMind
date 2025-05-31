import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final String? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines,
    this.maxLength,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = AppColors().palette;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: textTheme.bodyMedium?.copyWith(color: colorPalette.content),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder,
        prefixIcon: widget.prefixIcon != null ? CustomIcon(icon: widget.prefixIcon!) : null,
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: CustomIcon(icon: obscureText ? 'viewOff' : 'view'),
                  onPressed: () => setState(() => obscureText = !obscureText),
                )
                : widget.suffixIcon,
      ),
    );
  }
}
