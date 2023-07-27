import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? menuColor;
  final Function()? onTap;
  const ProfileMenu({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.menuColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Icon(
              icon,
              color: menuColor,
            ),
            const SizedBox(width: 24),
            Text(
              label,
              style: TextStyles.normalText.copyWith(color: menuColor),
            )
          ],
        ),
      ),
    );
  }
}
