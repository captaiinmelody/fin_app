// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent {}

class SaveRegisterEvent extends RegistrationEvent {
  final RegisterModel registerModels;
  SaveRegisterEvent({
    required this.registerModels,
  });
}
