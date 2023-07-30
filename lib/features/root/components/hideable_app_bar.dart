import 'package:fin_app/constant/color.dart';
import 'package:flutter/material.dart';

class HideableAppBar extends StatelessWidget {
  final Widget? child;
  final List<Widget>? icon;
  final double? height;
  const HideableAppBar({super.key, this.child, this.icon, this.height});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      snap: true,
      toolbarHeight: height ?? 56,
      backgroundColor: AppColors.primaryColor,
      actions: icon,
      centerTitle: true,
      expandedHeight: 80,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 24),
        centerTitle: true,
        title: child,
      ),
    );
  }
}
