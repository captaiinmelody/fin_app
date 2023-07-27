import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class RoleContainer extends StatelessWidget {
  final String? role;
  const RoleContainer({
    super.key,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.secondaryColor),
      child: Center(
        child: Text(role ?? "null",
            style: TextStyles.normalText
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
