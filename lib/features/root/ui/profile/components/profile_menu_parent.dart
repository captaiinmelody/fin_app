import 'package:fin_app/features/root/ui/profile/components/profile_menu.dart';
import 'package:flutter/material.dart';

class ProfileMenuParent extends StatelessWidget {
  final Function()? settingsOnTap,
      achivementOnTap,
      aboutOnTap,
      rateUsOnTap,
      logoutOnTap,
      downloadOnTap;
  final String? role;
  const ProfileMenuParent({
    super.key,
    this.settingsOnTap,
    this.achivementOnTap,
    this.aboutOnTap,
    this.rateUsOnTap,
    this.logoutOnTap,
    this.downloadOnTap,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
            child: Column(children: [
              ProfileMenu(
                  onTap: logoutOnTap,
                  label: "Keluar",
                  icon: Icons.logout_outlined,
                  menuColor: Colors.redAccent)
            ])));
  }
}
