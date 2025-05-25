import 'package:flutter/material.dart';
import 'package:studymind/theme/colors.dart';
import 'package:studymind/widgets/custom_icon.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
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
      style: textTheme.bodyMedium?.copyWith(color: colorPalette.content),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: CustomIcon(icon: widget.prefixIcon),
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
