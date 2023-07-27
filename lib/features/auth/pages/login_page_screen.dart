import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/bloc/login/login_bloc.dart';
import 'package:fin_app/features/firebase/auth/components/auth_button_component.dart';
import 'package:fin_app/features/firebase/auth/components/auth_input_components.dart';
import 'package:fin_app/features/firebase/auth/components/auth_question_components.dart';
import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/request/login_models.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  late bool isObscureText = true;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    // isLogin();
    super.initState();
  }

  void isLogin() async {
    final isTokenExist = await AuthLocalStorage().isTokenExist();
    final isAdmin = await AuthDataSources().getProfile();
    if (isTokenExist) {
      // ignore: use_build_context_synchronously
      if (isAdmin.role == 'admin') {
        GoRouter.of(context).goNamed(MyRouterConstant.adminHomeRouterName);
      } else {
        GoRouter.of(context).goNamed(MyRouterConstant.homeRouterName);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("FIN APP"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login",
              style: TextStyles.titleText,
            ),
            Text(
              "Welcome to FIN APP. Please enter your account information to log in",
              style: TextStyles.smallText.copyWith(),
            ),
            const SizedBox(height: 50),
            AuthForm(
              controller: emailController,
              labelText: "Email",
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 24),
            AuthForm(
              controller: passwordController,
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock_outline),
              obscureText: isObscureText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: isObscureText
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                GoRouter.of(context)
                    .goNamed(MyRouterConstant.forgotPasswordRouterName);
              },
              child: Text(
                "Forgot Password?",
                style: TextStyles.normalText
                    .copyWith(color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 80),
            Column(
              children: [
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoaded) {
                      emailController!.clear();
                      passwordController!.clear();
                      GoRouter.of(context)
                          .goNamed(MyRouterConstant.adminHomeRouterName);
                    } else if (state is LoginError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text('Login Failed')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.black, size: 20),
                      );
                    }
                    return AuthButton(
                        textButton: "Login",
                        onTap: () {
                          final requestModel = LoginModels(
                              email: emailController!.text,
                              password: passwordController!.text);
                          context
                              .read<LoginBloc>()
                              .add(DoLoginEvent(loginModel: requestModel));
                        });
                  },
                ),
                const SizedBox(height: 12),
                QuestionText(
                  questionText: "Don't have an account?",
                  answerText: "Register",
                  onTap: () {
                    GoRouter.of(context)
                        .goNamed(MyRouterConstant.registerRouterName);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
