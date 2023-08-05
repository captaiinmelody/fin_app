import 'package:fin_app/constant/color.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/components/show_case_view.dart';
import 'package:fin_app/features/root/data/localstorage/root_local_storage.dart';
import 'package:fin_app/features/root/ui/reports/pages/reports_page.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcaseview.dart';

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
  bool? showcaseCompleted;

  getRole() async {
    isAdmin = await AuthLocalStorage().isRoleAdmin();
  }

  startShowcase() async {
    final pref = await RootLocalStorgae().getRootPageShowCase();
    if (pref == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        ShowCaseWidget.of(context).startShowCase(
          [key1, key2],
        );
      });
    }
  }

  @override
  void initState() {
    getRole();
    askForPermission();
    startShowcase();
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
          ? ShowCaseView(
              globalKey: key2,
              description: 'Tekan tombol ini untuk membuat laporan',
              child: Builder(builder: (context) {
                return FloatingActionButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ShowCaseWidget(
                            onFinish: () async {
                              await RootLocalStorgae()
                                  .reportsPageShowCase(true);
                            },
                            builder: Builder(builder: (context) {
                              return ReportsPage(
                                rootBloc: rootBloc,
                                isAdmin: false,
                                reportsId: '',
                              );
                            }),
                          );
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
                );
              }),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ShowCaseView(
        globalKey: key1,
        description: 'Klik icon di bawah ini untuk berpindah halaman',
        child: Builder(builder: (context) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: calculateSelectedIndex(context),
            onTap: (int index) {
              setState(() => onItemTapped(index, context));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report),
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Peringkat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          );
        }),
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
