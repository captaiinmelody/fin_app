import 'package:fin_app/constant/color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final Widget child;
  const CustomAppBar({
    super.key,
    required this.child,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        constraints:
            BoxConstraints(minHeight: size.height * 0.3, minWidth: size.width),
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 24),
        decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        child: widget.child);
  }
}
