import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/firebase/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/components/custom_app_bar.dart';
import 'package:fin_app/features/root/components/profile_menu.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBar(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.symmetric(vertical: 12),
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
                  "maul",
                  style: TextStyles.titleText.copyWith(color: Colors.white),
                ),
                Text(
                  "mau28lana@gmail.com",
                  style: TextStyles.normalText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 50, 32, 32),
              child: Column(
                children: [
                  ProfileMenu(
                    onTap: () {},
                    label: "Account Settings",
                    icon: Icons.settings_outlined,
                  ),
                  ProfileMenu(
                    onTap: () {},
                    label: "Achievement",
                    icon: Icons.military_tech_outlined,
                  ),
                  ProfileMenu(
                    onTap: () {},
                    label: "About",
                    icon: Icons.error_outline,
                  ),
                  ProfileMenu(
                    onTap: () {},
                    label: "Rate Us",
                    icon: Icons.star_outline,
                  ),
                  ProfileMenu(
                    onTap: () {
                      // AuthLocalStorage().removeToken();
                      showDialog(
                          context: context,
                          builder: (context) => logOutConfirmation());
                    },
                    label: "Log Out",
                    icon: Icons.logout_outlined,
                    menuColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  logOutConfirmation() {
    // Size size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('../../../../../assets/logout_modal.png'),
            // const SizedBox(height: 24.0),
            const Text(
              'Logout Account?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text('Are you sure want to logout?'),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.red,
                      fixedSize: const Size(100, 10)),
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    AuthLocalStorage().removeToken();
                    GoRouter.of(context)
                        .goNamed(MyRouterConstant.rootRouterName);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(100, 10)),
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
