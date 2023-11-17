import 'package:fin_app/features/auth/data/datasources/auth_sources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(InitialState()) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    on<LoginEvent>((event, emit) async {
      if (event.email == "" && event.password == "") {
        emit(LoginState(
            isLoading: false,
            isError: true,
            message: 'Email dan Password harus diisi!'));
      } else if (event.email != "") {
        if (!emailRegex.hasMatch(event.email!)) {
          emit(LoginState(
              isLoading: false, isError: true, message: 'Format email salah.'));
        } else if (event.password == "") {
          emit(LoginState(
              isLoading: false,
              isError: true,
              message: 'Password harus diisi!'));
        } else {
          emit(LoginState(isLoading: true, isError: false));
          try {
            final user =
                await authRepository.login(event.email!, event.password!);
            final userToken = user!.token;
            final userId = user.id;
            await AuthLocalStorage().saveToken(userToken);
            await AuthLocalStorage().saveUserId(userId);
            emit(
                LoginState(isLoading: false, isError: false, token: userToken));

            authRepository.loginDebug(user);
          } catch (e) {
            if (e is AuthException) {
              if (e.message!.startsWith("The password")) {
                emit(LoginState(
                    isLoading: false,
                    isError: true,
                    message: "Password yang anda masukkan salah, coba lagi"));
              } else if (e.message!.startsWith("There is no user")) {
                emit(LoginState(
                    isLoading: false,
                    isError: true,
                    message:
                        "Akun anda tidak ditemukan, cek kembali email anda"));
              } else {
                emit(LoginState(
                    isLoading: false,
                    isError: true,
                    message: e.message.toString()));
              }
            } else {
              emit(LoginState(
                  isLoading: false,
                  isError: true,
                  message: 'Login gagal, silahkan coba lagi.'));
            }
          }
        }
      } else {
        emit(LoginState(
            isLoading: false, isError: true, message: 'Email harus diisi!.'));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(RegisterState(isLoading: true, isError: false, message: ""));

      List<String> missingFields = [];
      bool validationMet = true;

      if (event.username == "") {
        missingFields.add("Username");
        validationMet = false;
      }
      if (event.email == "") {
        missingFields.add("Email");
        validationMet = false;
      }
      if (event.password == "") {
        missingFields.add("Password");
        validationMet = false;
      }
      if (event.confPassword == "") {
        missingFields.add("Confirm Password");
        validationMet = false;
      }

      String combinedMessage = "${missingFields.join(", ")} Tidak Boleh Kosong";

      if (validationMet) {
        if (!emailRegex.hasMatch(event.email)) {
          emit(RegisterState(
            isLoading: false,
            isError: true,
            message: "Masukkan email yang valid, contoh: asd@gmail.com",
          ));
        } else if (event.jabatan.isEmpty) {
          emit(RegisterState(
            isLoading: false,
            isError: true,
            message: "Pilih salah satu jabatan",
          ));
        } else if (event.password.length <= 5) {
          emit(RegisterState(
            isLoading: false,
            isError: true,
            message: "Password tidak boleh kurang dari 6 karakter",
          ));
        } else if (event.password != event.confPassword) {
          emit(RegisterState(
            isLoading: false,
            isError: true,
            message: "Password and Confirm Password tidak sama",
          ));
        } else {
          try {
            final UserModel userModels = UserModel(
              username: event.username,
              email: event.email,
              jabatan: event.jabatan,
              nim: event.nim,
            );
            final response = await authRepository.register(
              email: event.email,
              password: event.password,
              userModels: userModels,
            );

            if (response) {
              emit(RegisterState(
                isLoading: false,
                isError: false,
                message:
                    "Registrasi berhasil! Lakukan login untuk masuk ke dalam sistem.",
              ));

              authRepository.registerDebug(userModels);
            } else {
              emit(RegisterState(
                isLoading: false,
                isError: true,
                message: "Email anda sudah dipakai, coba ganti email yang lain",
              ));
            }
          } catch (e) {
            if (e is AuthException) {
              emit(RegisterState(
                isLoading: false,
                isError: true,
                message: e.message,
              ));
            } else {
              emit(RegisterState(
                isLoading: false,
                isError: true,
                message: 'Registrasi gagal, coba lagi.',
              ));
            }
          }
        }
      } else {
        emit(RegisterState(
          isLoading: false,
          isError: true,
          message: combinedMessage,
        ));
      }
    });
  }

  login(String email, String password) {}
}
