import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final String? labelText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final Color? fillColor;
  final double? height;
  final TextEditingController? controller;
  const CustomForm({
    super.key,
    this.obscureText,
    this.labelText,
    this.suffixIcon,
    this.fillColor,
    this.prefixIcon,
    this.controller,
    this.height,
  });

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextFormField(
            controller: controller,
            obscureText: obscureText ?? false,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                labelText: labelText ?? 'Label Input',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12)))));
  }
}
