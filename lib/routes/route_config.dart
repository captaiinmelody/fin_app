import 'package:fin_app/features/firebase/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/firebase/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/firebase/auth/pages/login_page.dart';
import 'package:fin_app/features/firebase/auth/data/datasources/auth_sources.dart';
import 'package:fin_app/features/firebase/auth/pages/register_page.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/data/datasources/leaderboards_sources.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/root_page.dart';
import 'package:fin_app/features/root/ui/home/pages/home_page.dart';
import 'package:fin_app/features/root/ui/leaderboards/pages/leaderboards_page.dart';
import 'package:fin_app/features/root/ui/my_reports/pages/my_reports_page.dart';
import 'package:fin_app/features/root/ui/profile/profile_page.dart';
import 'package:fin_app/features/root/ui/reports/pages/reports_page.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> adminNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'admin');
final GlobalKey<NavigatorState> userNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user');

final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

final AuthRepository _authRepository = AuthRepository();
final AuthBloc authBloc = AuthBloc(_authRepository);

final ReportsDataSources reportsDataSources = ReportsDataSources();
final LeaderboardSources leaderboardSources = LeaderboardSources();

final RootBloc rootBloc = RootBloc(reportsDataSources, leaderboardSources);

class MyRouter {
  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
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
                return MaterialPage(child: RegisterPage(authBloc: authBloc));
              }),
        ],
      ),

      //admin router
      ShellRoute(
          navigatorKey: adminNavigatorKey,
          builder: (context, state, child) {
            return RootPage(
              child: child,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              name: MyRouterConstant.homeRouterName,
              path: '/home',
              pageBuilder: (context, state) {
                return const MaterialPage(child: HomePage());
              },
            ),
            GoRoute(
              name: MyRouterConstant.profileRouterName,
              path: '/profile',
              pageBuilder: (context, state) {
                return const MaterialPage(child: ProfilePage());
              },
            ),
            GoRoute(
              name: MyRouterConstant.myReportsRouterName,
              path: '/my-reports',
              pageBuilder: (context, state) {
                return const MaterialPage(child: MyReportsPage());
              },
            ),
            GoRoute(
              name: MyRouterConstant.leaderboardsRouterName,
              path: '/leaderboards',
              pageBuilder: (context, state) {
                return const MaterialPage(child: LeaderboardsPage());
              },
            ),
            GoRoute(
              name: MyRouterConstant.reportsRouterName,
              path: '/reports',
              pageBuilder: (context, state) {
                return MaterialPage(child: ReportsPage(rootBloc: rootBloc));
              },
            ),
          ]),

      //user router
    ],
    redirect: (context, state) async {
      final isLogedIn = await AuthLocalStorage().isTokenExist();

      //auth redirect
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';
      // final isGoingToResetPassword = state.matchedLocation == '/';

      //root redirect
      final isHomeLocation = state.matchedLocation == '/home';
      final isProfileLocation = state.matchedLocation == '/profile';
      final isMyReportsLocation = state.matchedLocation == '/my-reports';
      final isLeaderboardsLocation = state.matchedLocation == '/leaderboards';

      if (isLogedIn) {
        if (isHomeLocation) {
          return '/home';
        } else if (isProfileLocation) {
          return '/profile';
        } else if (isMyReportsLocation) {
          return '/my-reports';
        } else if (isLeaderboardsLocation) {
          return '/leaderboards';
        }
        return '/home'; // Default redirect for logged-in users
      } else {
        if (isGoingToLogin) {
          return '/login';
        } else if (isGoingToRegister) {
          return '/register';
        }
        return '/login'; // Default redirect for non-logged-in users
      }
    },
    errorPageBuilder: (context, state) {
      return const MaterialPage(
          child: Scaffold(body: Center(child: Text('Not Found'))));
    },
  );
}
