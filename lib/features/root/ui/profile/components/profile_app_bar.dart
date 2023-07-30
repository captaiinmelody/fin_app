import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final String? username, email;
  const ProfileAppBar({
    super.key,
    this.username,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(bottom: 24),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.grey.withOpacity(0.8),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      splashColor: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: Container(
                        color: AppColors.secondaryColor,
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        Text(
          username ?? "maul",
          style: TextStyles.titleText.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          email ?? "mau28lana@gmail.com",
          style: TextStyles.normalText.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
