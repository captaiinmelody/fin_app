part of 'auth_bloc.dart';

abstract class AuthState {}

class InitialState extends AuthState {}

class LoginState extends AuthState {
  final String? token, message;
  final bool isLoading, isError;
  LoginState({
    this.token,
    this.message,
    required this.isLoading,
    required this.isError,
  });
}

class RegisterState extends AuthState {
  final String? message;
  final bool isLoading, isError;
  RegisterState({
    this.message,
    required this.isLoading,
    required this.isError,
  });
}

class AuthException extends AuthState implements Exception {
  final String? message;
  AuthException({this.message});
}

// class LoadingState extends AuthState {}

// class AuthenticatedState extends AuthState {
//   final String token;
//   AuthenticatedState(this.token);
// }

// class RegistrationCompleteState extends AuthState {
//   final String successMessage;
//   RegistrationCompleteState(this.successMessage);
// }

// class LoginErrorState extends AuthState {
//   final String? message;
//   LoginErrorState({this.message});
// }

// class RegisterErrorState extends AuthState {
//   final String? message;
//   RegisterErrorState({this.message});
// }
