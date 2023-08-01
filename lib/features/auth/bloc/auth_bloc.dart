import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/response/user_response_models.dart';
import 'package:fin_app/features/firebase/auth/data/datasources/auth_sources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(InitialState()) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    on<LoginEvent>((event, emit) async {
      emit(LoadingState());
      try {
        List<String> missingFields = [];
        if (event.email == '') {
          missingFields.add("Email");
        }
        if (event.password == '') {
          missingFields.add("Password");
        }
        String combinedMessage = "${missingFields.join(", ")} cannot be empty";

        if (event.email != '' && event.password != '') {
          if (!emailRegex.hasMatch(event.email!)) {
            emit(ErrorState(
                message:
                    "Please enter the correct email example: asd@gmail.com"));
          } else if (event.password!.length <= 5) {
            emit(ErrorState(
                message: "Password should be at least 6 characters"));
          } else {
            final user =
                await authRepository.login(event.email!, event.password!);
            final userToken = user!.token;
            final userId = user.id;
            await AuthLocalStorage().saveToken(userToken);
            await AuthLocalStorage().saveUserId(userId);
            emit(AuthenticatedState(userToken));
          }
        } else {
          emit(ErrorState(message: combinedMessage));
        }
      } catch (e) {
        if (e is AuthException) {
          emit(ErrorState(message: e.toString())); // Emit the error message
        } else {
          emit(ErrorState(message: 'Login failed. Please try again.'));
        }
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(LoadingState());

      List<String> missingFields = [];
      if (event.username == '') {
        missingFields.add("Username");
      }
      if (event.email == '') {
        missingFields.add("Email");
      }
      if (event.password == '') {
        missingFields.add("Password");
      }
      if (event.confPassword == '') {
        missingFields.add("Confirm Password");
      }
      if (event.confPassword == '') {
        missingFields.add("Confirm Password");
      }

      String combinedMessage = "${missingFields.join(", ")} cannot be empty";

      if (event.username != "" &&
          event.email != "" &&
          event.password != '' &&
          event.confPassword != '') {
        if (!emailRegex.hasMatch(event.email!)) {
          emit(ErrorState(
              message:
                  "Please enter the correct email example: asd@gmail.com"));
        } else if (event.password!.length <= 5) {
          emit(ErrorState(message: "Password should be at least 6 characters"));
        } else if (event.password != event.confPassword) {
          emit(ErrorState(
              message: "Password and Confirm Pssword should be the same!"));
        } else {
          try {
            final response = await authRepository.register(
                event.email!,
                event.password!,
                UserResponseModels(
                  username: event.username,
                  email: event.email,
                ));
            if (response) {
              emit(RegistrationCompleteState(
                  "Registered success! You can login now."));
            } else {
              emit(ErrorState(
                  message: "Username already exist, try different one"));
            }
          } catch (e) {
            emit(ErrorState(message: e.toString()));
          }
        }
      } else {
        emit(ErrorState(message: combinedMessage));
      }
    });
    on<ForgotPasswordEvent>((event, emit) async {
      emit(LoadingState());
      try {
        // Perform login with Firebase
        // Replace the following line with your Firebase authentication code
        await authRepository.forgotPassword(event.email);
        emit(InitialState());
      } catch (e) {
        emit(ErrorState(message: 'Registration failed. Please try again.'));
      }
    });
  }
}

//   Stream<AuthState> mapEventToState(AuthEvent event) async* {
//     if (event is LoginEvent) {
//       yield LoadingState();
//       try {
//         // Perform login with Firebase
//         // Replace the following line with your Firebase authentication code
//         final user = await _authRepository.login(event.email, event.password);
//         yield AuthenticatedState(user);
//       } catch (e) {
//         yield ErrorState('Login failed. Please try again.');
//       }
//     } else if (event is RegisterEvent) {
//       yield LoadingState();
//       try {
//         // Perform registration with Firebase
//         // Replace the following line with your Firebase authentication code
//         final user =
//             await _authRepository.register(event.email, event.password);
//         yield AuthenticatedState(user);
//       } catch (e) {
//         yield ErrorState('Registration failed. Please try again.');
//       }
//     } else if (event is ForgotPasswordEvent) {
//       yield LoadingState();
//       try {
//         // Perform forgot password request with Firebase
//         // Replace the following line with your Firebase authentication code
//         await _authRepository.forgotPassword(event.email);
//         yield InitialState();
//       } catch (e) {
//         yield ErrorState('Forgot password failed. Please try again.');
//       }
//     }
//   }
// }
