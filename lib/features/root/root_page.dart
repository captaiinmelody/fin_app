import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/firebase/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/ui/reports/pages/reports_page.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class RootPage extends StatefulWidget {
  final Widget child;
  const RootPage({super.key, required this.child});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final RootBloc rootBloc = RootBloc(
    adminReportsDataSources,
    reportsDataSources,
    leaderboardSources,
    profileDataSources,
  );

  List routerName = [
    MyRouterConstant.homeRouterName,
    MyRouterConstant.profileRouterName,
  ];

  bool? isAdmin;

  getRole() async {
    isAdmin = await AuthLocalStorage().isRoleAdmin();
  }

  @override
  void initState() {
    getRole();
    askForPermission();
    super.initState();
  }

  void askForPermission() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.microphone.request();
    await Permission.location.request();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: widget.child,
      floatingActionButton: isAdmin == false
          ? FloatingActionButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ReportsPage(rootBloc: rootBloc);
                    });
              },
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: const Icon(
                Icons.report_sharp,
                size: 32,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: calculateSelectedIndex(context),
        onTap: (int index) {
          setState(() => onItemTapped(index, context));
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'My Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Leaderboards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static calculateSelectedIndex(context) {
    final String location = GoRouterState.of(context).location;
    if (location == '/home') {
      return 0;
    }
    if (location == '/my-reports') {
      return 1;
    }
    if (location == '/leaderboards') {
      return 2;
    }
    if (location == '/profile') {
      return 3;
    }
    return 0;
  }

  void onItemTapped(index, context) {
    switch (index) {
      case 0:
        GoRouter.of(context).goNamed(MyRouterConstant.homeRouterName);
        break;
      case 1:
        GoRouter.of(context).goNamed(MyRouterConstant.myReportsRouterName);
        break;
      case 2:
        GoRouter.of(context).goNamed(MyRouterConstant.leaderboardsRouterName);
        break;
      case 3:
        GoRouter.of(context).goNamed(MyRouterConstant.profileRouterName);
        break;
    }
  }
}
