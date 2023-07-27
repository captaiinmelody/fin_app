import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class HideableAppBar extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const HideableAppBar({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      snap: true,
      backgroundColor: AppColors.primaryColor,
      actions: [
        IconButton(
            onPressed: onPressed ?? () {},
            icon: const Icon(
              Icons.search,
              size: 36,
              color: Colors.white,
            ))
      ],
      centerTitle: true,
      expandedHeight: 80,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12))),
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(bottom: 24),
          centerTitle: true,
          title: Text(title,
              style: TextStyles.titleText.copyWith(color: Colors.white))),
    );
  }
}
