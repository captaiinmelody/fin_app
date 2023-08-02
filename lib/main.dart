import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/auth/data/datasources/auth_sources.dart';
import 'package:fin_app/features/root/bloc/root_bloc.dart';
import 'package:fin_app/firebase_options.dart';
import 'package:fin_app/routes/route_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(
            create: (context) => RootBloc(
                  adminReportsDataSources,
                  reportsDataSources,
                  leaderboardSources,
                  profileDataSources,
                ))
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, textTheme: const TextTheme()),
        routerConfig: MyRouter.router,
      ),
    );
  }
}
