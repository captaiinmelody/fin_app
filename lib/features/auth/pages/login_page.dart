import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/auth/components/auth_input_components.dart';
import 'package:fin_app/features/auth/components/auth_question_components.dart';
import 'package:fin_app/features/firebase/auth/components/auth_button_component.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  final AuthBloc authBloc;
  const LoginPage({super.key, required this.authBloc});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isObscureText = true;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
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
                BlocConsumer<AuthBloc, AuthState>(
                  bloc: widget.authBloc,
                  listener: (context, state) {
                    if (state is AuthenticatedState) {
                      setState(() {
                        emailController!.clear();
                        passwordController!.clear();
                        GoRouter.of(context)
                            .goNamed(MyRouterConstant.homeRouterName);
                      });
                    } else if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(state.message!)));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.black, size: 20),
                      );
                    }
                    return AuthButton(
                        textButton: "Login",
                        onTap: () {
                          widget.authBloc.add(LoginEvent(
                            emailController!.text,
                            passwordController!.text,
                          ));
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
