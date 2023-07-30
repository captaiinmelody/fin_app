import 'package:fin_app/features/root/ui/profile/components/profile_menu.dart';
import 'package:flutter/material.dart';

class ProfileMenuParent extends StatelessWidget {
  final Function()? settingsOnTap,
      achivementOnTap,
      aboutOnTap,
      rateUsOnTap,
      logoutOnTap;
  const ProfileMenuParent({
    super.key,
    this.settingsOnTap,
    this.achivementOnTap,
    this.aboutOnTap,
    this.rateUsOnTap,
    this.logoutOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
        child: Column(
          children: [
            ProfileMenu(
              onTap: settingsOnTap,
              label: "Account Settings",
              icon: Icons.settings_outlined,
            ),
            ProfileMenu(
              onTap: achivementOnTap,
              label: "Achievement",
              icon: Icons.military_tech_outlined,
            ),
            ProfileMenu(
              onTap: aboutOnTap,
              label: "About",
              icon: Icons.error_outline,
            ),
            ProfileMenu(
              onTap: aboutOnTap,
              label: "Rate Us",
              icon: Icons.star_outline,
            ),
            ProfileMenu(
              onTap: logoutOnTap,
              label: "Log Out",
              icon: Icons.logout_outlined,
              menuColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
