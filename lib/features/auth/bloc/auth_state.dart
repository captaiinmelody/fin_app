part of 'auth_bloc.dart';

abstract class AuthState {}

class InitialState extends AuthState {}

class LoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final String token;

  AuthenticatedState(this.token);
}

class RegistrationCompleteState extends AuthState {
  final String successMessage;

  RegistrationCompleteState(this.successMessage);
}

class UnauthenticatedState extends AuthState {}

class ErrorState extends AuthState {
  final String? message;

  ErrorState({this.message});
}

class AuthException extends AuthState implements Exception {
  final String? message;

  AuthException({
    this.message,
  });

  @override
  String toString() {
    return message ?? "Unknown error occurred";
  }
}
