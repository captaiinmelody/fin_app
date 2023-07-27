// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/models/request/register_model.dart';
import 'package:fin_app/features/auth/data/models/response/register_response_model.dart';
import 'package:flutter/material.dart';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthDataSources dataSources;
  RegistrationBloc(
    this.dataSources,
  ) : super(RegistrationInitial()) {
    on<SaveRegisterEvent>((event, emit) async {
      emit(RegistrationLoading());

      try {
        String combinedMessage = "${[
          if (event.registerModels.name == null) "Username",
          if (event.registerModels.email == null) "Email",
          if (event.registerModels.password == null) "Password",
          if (event.registerModels.confPassword == null) "Confirm password",
        ].join(", ")} cannot be empty";

        emit(RegistrationError(message: combinedMessage));

        if (event.registerModels.password ==
            event.registerModels.confPassword) {
          final result = await dataSources.register(event.registerModels);

          emit(RegistrationLoaded(registrationResponseModel: result));
        } else {
          emit(RegistrationError(
              message: "Password and Confirm password is not the same"));
        }
      } catch (e) {
        emit(RegistrationError(message: e.toString()));
      }
    });
  }
}
