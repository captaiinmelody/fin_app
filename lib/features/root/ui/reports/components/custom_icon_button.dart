import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  final String label;
  final Color? labelColor;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.labelColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              icon,
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: labelColor)),
            ])));
  }
}
