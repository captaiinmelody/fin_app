// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final RegisterResponseModel registrationResponseModel;
  RegistrationLoaded({
    required this.registrationResponseModel,
  });
}

class RegistrationError extends RegistrationState {
  final String? message;

  RegistrationError({this.message});
}
