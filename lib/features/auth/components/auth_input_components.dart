import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final String? labelText;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Icon? prefixIcon;
  final Color? fillColor;
  final TextEditingController? controller;
  const AuthForm({
    super.key,
    this.obscureText,
    this.labelText,
    this.suffixIcon,
    this.fillColor,
    this.prefixIcon,
    this.controller,
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
      height: 50,
      child: TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            labelText: labelText ?? 'Label Input',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.red), // Set the filled border color
              borderRadius: BorderRadius.circular(12),
            ),
          )),
    );
  }
}
