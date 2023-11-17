import 'package:fin_app/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  final Widget child;
  final GlobalKey globalKey;
  final String? title;
  final String description;

  const ShowCaseView({
    super.key,
    required this.child,
    required this.globalKey,
    this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: globalKey,
        title: title,
        description: description,
        descTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        tooltipPadding: const EdgeInsets.all(8),
        tooltipBackgroundColor: AppColors.primaryColor,
        tooltipBorderRadius: BorderRadius.circular(12),
        child: child);
  }
}
