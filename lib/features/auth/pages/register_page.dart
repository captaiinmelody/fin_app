import 'package:fin_app/constant/text_styles.dart';
import 'package:fin_app/features/auth/bloc/auth_bloc.dart';
import 'package:fin_app/features/root/components/custom_button.dart';
import 'package:fin_app/features/root/components/custom_form.dart';
import 'package:fin_app/features/auth/components/auth_question_components.dart';
import 'package:fin_app/features/root/components/dropdown_field.dart';
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

  String selectedJabatan = "";
  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? nimController;
  TextEditingController? passwordController;
  TextEditingController? confPasswordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    nimController = TextEditingController();
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
    return Scaffold(
        appBar: AppBar(
            title: const Text("FIN APP"), automaticallyImplyLeading: false),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Register", style: TextStyles.titleText),
              Text(
                  "Welcome to FIN APP. Please enter your account information to Register",
                  style: TextStyles.smallText.copyWith()),
              const SizedBox(height: 50),
              DropdownField(
                  page: "registrasi",
                  labelText: 'Pilih Jabatan Anda Di UAD',
                  icon: const Icon(Icons.person_outline),
                  isEnabled: false,
                  onChanged: (selectedValue) {
                    setState(() {
                      selectedJabatan = selectedValue;
                    });
                  }),
              const SizedBox(height: 24),
              CustomForm(
                  controller: usernameController,
                  labelText: "Nama Lengkap",
                  prefixIcon: const Icon(Icons.person_outline)),
              const SizedBox(height: 24),
              CustomForm(
                  controller: nimController,
                  labelText: "NIM / NIY",
                  prefixIcon: const Icon(Icons.person_outline)),
              const SizedBox(height: 24),
              CustomForm(
                  controller: emailController,
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined)),
              const SizedBox(height: 24),
              CustomForm(
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
                          : const Icon(Icons.visibility_off_outlined))),
              const SizedBox(height: 24),
              CustomForm(
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
                          : const Icon(Icons.visibility_off_outlined))),
              const SizedBox(height: 80),
              Column(children: [
                BlocConsumer<AuthBloc, AuthState>(
                    bloc: widget.authBloc,
                    listener: (context, state) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();

                      if (state is RegisterState &&
                          !state.isLoading &&
                          state.message!.isNotEmpty) {
                        usernameController!.clear();
                        emailController!.clear();
                        passwordController!.clear();
                        confPasswordController!.clear();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              state.isError ? Colors.redAccent : Colors.green,
                          content: Text(state.message!),
                        ));

                        if (!state.isError) {
                          GoRouter.of(context)
                              .goNamed(MyRouterConstant.loginRouterName);
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterState) {
                        if (state.isLoading) {
                          return Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                      color: Colors.black, size: 20));
                        }
                      }
                      return CustomButton(
                          textButton: "Register",
                          onTap: () {
                            widget.authBloc.add(RegisterEvent(
                              email: emailController!.text,
                              password: passwordController!.text,
                              username: usernameController!.text,
                              confPassword: confPasswordController!.text,
                              jabatan: selectedJabatan,
                              nim: nimController!.text,
                            ));
                          });
                    }),
                const SizedBox(height: 12),
                QuestionText(
                    questionText: "Already have an account?",
                    answerText: "Login",
                    onTap: () {
                      GoRouter.of(context)
                          .goNamed(MyRouterConstant.loginRouterName);
                    })
              ])
            ])));
  }
}
