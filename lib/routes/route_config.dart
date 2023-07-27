import 'package:fin_app/features/firebase/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/firebase/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/firebase/auth/pages/login_page.dart';
import 'package:fin_app/features/firebase/auth/data/repo/auth_repo.dart';
import 'package:fin_app/features/firebase/auth/pages/register_page.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/root_page.dart';
import 'package:fin_app/features/root/ui/home/pages/home_page.dart';
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
final AuthRepository _authRepository = AuthRepository();
final AuthBloc authBloc = AuthBloc(_authRepository);

final ReportsDataSources reportsDataSources = ReportsDataSources();
final RootBloc rootBloc = RootBloc(reportsDataSources);

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

      if (isLogedIn) {
        if (isHomeLocation) {
          return '/home';
        } else if (isProfileLocation) {
          return '/profile';
        }
        return '/home';
      } else if (!isLogedIn) {
        if (isGoingToLogin) {
          return '/login';
        } else if (isGoingToRegister) {
          return '/register';
        }
        return '/login';
      }

      return null;
    },
    errorPageBuilder: (context, state) {
      return const MaterialPage(
          child: Scaffold(body: Center(child: Text('Not Found'))));
    },
  );
}
