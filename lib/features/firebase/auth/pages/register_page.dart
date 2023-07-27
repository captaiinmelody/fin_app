import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/firebase/auth/components/auth_button_component.dart';
import 'package:fin_app/features/firebase/auth/components/auth_input_components.dart';
import 'package:fin_app/features/firebase/auth/components/auth_question_components.dart';
import 'package:fin_app/features/firebase/auth/bloc/auth_bloc.dart';
import 'package:fin_app/routes/route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterPage extends StatefulWidget {
  final AuthBloc authBloc;
  const RegisterPage({super.key, required this.authBloc});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool isPassword = true;
  late bool isConfirmPassword = true;

  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confPasswordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController!.dispose();
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
              controller: usernameController,
              labelText: "Username",
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
                child: isConfirmPassword
                    ? const Icon(Icons.visibility_outlined)
                    : const Icon(Icons.visibility_off_outlined),
              ),
            ),
            const SizedBox(height: 80),
            Column(
              children: [
                BlocConsumer<AuthBloc, AuthState>(
                  bloc: widget.authBloc,
                  listener: (context, state) {
                    if (state is RegistrationCompleteState) {
                      usernameController!.clear();
                      emailController!.clear();
                      passwordController!.clear();
                      confPasswordController!.clear();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(state.successMessage)));

                      GoRouter.of(context)
                          .goNamed(MyRouterConstant.loginRouterName);
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
                        textButton: "Register",
                        onTap: () {
                          widget.authBloc.add(RegisterEvent(
                            email: emailController!.text,
                            password: passwordController!.text,
                            username: usernameController!.text,
                            confPassword: confPasswordController!.text,
                          ));
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
