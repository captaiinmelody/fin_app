part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String? email, password;
  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String email, password, confPassword, username, jabatan, nim;
  final String? id, profilePhotoUrl, role;
  RegisterEvent(
      {required this.email,
      required this.password,
      required this.confPassword,
      required this.nim,
      required this.username,
      required this.jabatan,
      this.id,
      this.role,
      this.profilePhotoUrl});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}
