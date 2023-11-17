import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/auth/data/datasources/auth_sources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/pages/login_page.dart';
import 'package:fin_app/features/auth/pages/register_page.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/data/datasources/leaderboards_sources.dart';
import 'package:fin_app/features/root/data/datasources/notification_sources.dart';
import 'package:fin_app/features/root/data/datasources/profile_sources.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/data/localstorage/root_local_storage.dart';
import 'package:fin_app/features/root/root_page.dart';
import 'package:fin_app/features/root/ui/home/pages/home_page.dart';
import 'package:fin_app/features/root/ui/my_reports/pages/my_reports_page.dart';
// import 'package:fin_app/features/root/ui/notification/notification_history_page.dart';
// import 'package:fin_app/features/root/ui/reports/pages/reports_detail_page.dart';
import 'package:fin_app/features/root/ui/profile/pages/profile_page.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> adminNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'admin');
final GlobalKey<NavigatorState> userNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user');

final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

final AuthRepository _authRepository = AuthRepository();
final AuthBloc authBloc = AuthBloc(_authRepository);
final ReportsRepository reportsDataSources = ReportsRepository();
final LeaderboardSources leaderboardSources = LeaderboardSources();
final ProfileDataSources profileDataSources = ProfileDataSources();
final NotificationSources notificationSources = NotificationSources();

final RootBloc rootBloc = RootBloc(
  reportsRepository: reportsDataSources,
  profileDataSources: profileDataSources,
  notificationSources: notificationSources,
);

final key1 = GlobalKey();
final key2 = GlobalKey();
final key3 = GlobalKey();
final key4 = GlobalKey();
final key5 = GlobalKey();
final key6 = GlobalKey();
final key7 = GlobalKey();

class MyRouter {
  static GoRouter router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
            name: MyRouterConstant.rootRouterName,
            path: '/',
            pageBuilder: (context, state) {
              return MaterialPage(child: LoginPage(authBloc: authBloc));
            },
            routes: [
              GoRoute(
                  name: MyRouterConstant.loginRouterName,
                  path: 'login',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: LoginPage(authBloc: authBloc));
                  }),
              GoRoute(
                  name: MyRouterConstant.registerRouterName,
                  path: 'register',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                        child: RegisterPage(authBloc: authBloc));
                  }),
              // GoRoute(
              //     name: MyRouterConstant.notificationRouterName,
              //     path: 'notification',
              //     pageBuilder: (context, state) {
              //       return const MaterialPage(child: NotificationHistory());
              //     },
              //     routes: [
              //       GoRoute(
              //           name: MyRouterConstant.notificationDetailRouterName,
              //           path: ':reportsId',
              //           pageBuilder: (context, state) {
              //             final reportsId = state.pathParameters['reportsId'];
              //             return MaterialPage(
              //                 child: ReportsDetailPage(
              //               reportsId: reportsId!,
              //             ));
              //           })
              //     ]),
            ]),
        ShellRoute(
            navigatorKey: adminNavigatorKey,
            builder: (context, state, child) {
              return ShowCaseWidget(onFinish: () async {
                await RootLocalStorgae().saveRootPageShowCase(true);
                final rootPageShowcase =
                    await RootLocalStorgae().getRootPageShowCase();
                print(rootPageShowcase);
              }, builder: Builder(builder: (context) {
                return RootPage(child: child);
              }));
            },
            routes: <RouteBase>[
              GoRoute(
                  name: MyRouterConstant.homeRouterName,
                  path: '/home',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: HomePage(rootBloc: rootBloc));
                  }),
              GoRoute(
                  name: MyRouterConstant.profileRouterName,
                  path: '/profile',
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: ProfilePage());
                  }),
              GoRoute(
                  name: MyRouterConstant.myReportsRouterName,
                  path: '/my-reports',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                        child: MyReportsPage(rootBloc: rootBloc));
                  }),
            ])
      ],
      redirect: (context, state) async {
        final isLogedIn = await AuthLocalStorage().isTokenExist();
        final isGoingToLogin = state.matchedLocation == '/login';
        final isGoingToRegister = state.matchedLocation == '/register';
        final isHomeLocation = state.matchedLocation == '/home';
        final isProfileLocation = state.matchedLocation == '/profile';
        final isMyReportsLocation = state.matchedLocation == '/my-reports';
        final isNotificationLocation = state.matchedLocation == '/notification';
        final isNotificationDetailLocation =
            RegExp(r'^/notification/').hasMatch(state.matchedLocation);

        if (isLogedIn) {
          if (isHomeLocation) {
            return '/home';
          } else if (isProfileLocation) {
            return '/profile';
          } else if (isMyReportsLocation) {
            return '/my-reports';
          } else if (isMyReportsLocation) {
            return '/my-reports';
          } else if (isNotificationLocation) {
            return '/notification';
          } else if (isNotificationDetailLocation) {
            final reportsId = state.pathParameters['reportsId'];
            return '/notification/$reportsId';
          } else if (isGoingToLogin) {
            return '/home';
          }
          return '/home';
        } else {
          if (isGoingToLogin) {
            return '/login';
          } else if (isGoingToRegister) {
            return '/register';
          }
          return '/login';
        }
      },
      errorPageBuilder: (context, state) {
        return const MaterialPage(
            child: Scaffold(body: Center(child: Text('Not Found'))));
      });
}
