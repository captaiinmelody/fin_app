import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final String? username, email, jabatan;
  const ProfileAppBar({
    super.key,
    this.username,
    this.email,
    this.jabatan,
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
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                      color: Colors.grey.withOpacity(0.8),
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white)))),
          Text(username?.toUpperCase() ?? "username",
              style: TextStyles.titleText.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(jabatan ?? "jabatan",
              style: TextStyles.normalText.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(email ?? "useremail@gmail.com",
              style: TextStyles.normalText.copyWith(color: Colors.white)),
          const SizedBox(height: 12)
        ]);
  }
}
