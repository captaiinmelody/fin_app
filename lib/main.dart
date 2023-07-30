import 'package:fin_app/features/auth/bloc/login/login_bloc.dart';
import 'package:fin_app/features/auth/bloc/product/create_product/create_product_bloc.dart';
import 'package:fin_app/features/auth/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:fin_app/features/auth/bloc/profile/profile_bloc.dart';
import 'package:fin_app/features/auth/bloc/registration/registration_bloc.dart';
import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/dataresources/product_datasources.dart';
import 'package:fin_app/features/firebase/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/firebase/auth/data/datasources/auth_sources.dart';
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
        BlocProvider(create: (context) => LoginBloc(AuthDataSources())),
        BlocProvider(create: (context) => RegistrationBloc(AuthDataSources())),
        BlocProvider(
            create: (context) => ProfileBloc(AuthDataSources(),
                productDataSources: ProductDataSources())),
        BlocProvider(
            create: (context) => GetAllProductBloc(ProductDataSources())),
        BlocProvider(
            create: (context) => CreateProductBloc(ProductDataSources())),
        BlocProvider(create: (context) => AuthBloc(AuthRepository())),
        BlocProvider(
            create: (context) => RootBloc(
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
