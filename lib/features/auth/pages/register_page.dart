import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/bloc/registration/registration_bloc.dart';
import 'package:fin_app/features/firebase/auth/components/auth_button_component.dart';
import 'package:fin_app/features/firebase/auth/components/auth_input_components.dart';
import 'package:fin_app/features/firebase/auth/components/auth_question_components.dart';
import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/request/register_model.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterPageScreen extends StatefulWidget {
  const RegisterPageScreen({super.key});

  @override
  State<RegisterPageScreen> createState() => _RegisterPageScreenState();
}

class _RegisterPageScreenState extends State<RegisterPageScreen> {
  late bool isPassword = true;
  late bool isConfirmPassword = true;

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confPasswordController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
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
    nameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    confPasswordController!.dispose();
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
              "Register",
              style: TextStyles.titleText,
            ),
            Text(
              "Welcome to FIN APP. Please enter your account information to Register",
              style: TextStyles.smallText.copyWith(),
            ),
            const SizedBox(height: 50),
            AuthForm(
              controller: nameController,
              labelText: "Name",
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 24),
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
              obscureText: isPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isPassword = !isPassword;
                  });
                },
                child: isPassword
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
            ),
            const SizedBox(height: 24),
            AuthForm(
              controller: confPasswordController,
              labelText: "Confirm Password",
              prefixIcon: const Icon(Icons.lock_outline),
              obscureText: isConfirmPassword,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isConfirmPassword = !isConfirmPassword;
                  });
                },
                child: isPassword
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
            ),
            const SizedBox(height: 80),
            Column(
              children: [
                BlocConsumer<RegistrationBloc, RegistrationState>(
                  listener: (context, state) {
                    if (state is RegistrationLoaded) {
                      nameController!.clear();
                      emailController!.clear();
                      passwordController!.clear();
                      confPasswordController!.clear();
                      GoRouter.of(context)
                          .goNamed(MyRouterConstant.loginRouterName);
                    } else if (state is RegistrationError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(state.toString())));
                    }
                  },
                  builder: (context, state) {
                    if (state is RegistrationLoading) {
                      return Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.black, size: 20),
                      );
                    }
                    return AuthButton(
                        textButton: "Register",
                        onTap: () {
                          final requestModel = RegisterModel(
                              name: nameController!.text,
                              email: emailController!.text,
                              password: passwordController!.text);
                          context.read<RegistrationBloc>().add(
                              SaveRegisterEvent(registerModels: requestModel));
                        });
                  },
                ),
                const SizedBox(height: 12),
                QuestionText(
                  questionText: "Already have an account?",
                  answerText: "Login",
                  onTap: () {
                    GoRouter.of(context)
                        .goNamed(MyRouterConstant.loginRouterName);
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
