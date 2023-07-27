import 'package:fin_app/constant/color.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;
  final String label;
  final Color? labelColor;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.labelColor = Colors.black,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: icon,
          color: color,
          iconSize: 36,
        ),
        Text(
          label,
          style: TextStyle(color: labelColor),
        ),
      ],
    );
  }
}
