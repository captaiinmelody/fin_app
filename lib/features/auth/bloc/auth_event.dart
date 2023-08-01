part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String? email;
  final String? password;

  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String? email;
  final String? password;
  final String? confPassword;
  final String? id;
  final String? username;
  final String? bio;
  final DateTime? birthDate;
  final bool? isAdmin;
  final String? profilePhotoUrl;

  RegisterEvent({
    this.email,
    this.password,
    this.confPassword,
    this.id,
    this.username,
    this.bio,
    this.birthDate,
    this.isAdmin,
    this.profilePhotoUrl,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}
