// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/request/login_models.dart';
import 'package:fin_app/features/auth/data/models/response/login_response_model.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDataSources authDataSources;
  LoginBloc(this.authDataSources) : super(LoginInitial()) {
    on<DoLoginEvent>((event, emit) async {
      try {
        emit(LoginLoading());

        String combinedMessage = "${[
          if (event.loginModel.email == null) "Email",
          if (event.loginModel.password == null) "Password"
        ].join(", ")} cannot be empty";

        emit(LoginError(message: combinedMessage));

        if (event.loginModel.email != null &&
            event.loginModel.password != null) {
          final result = await authDataSources.login(event.loginModel);

          await AuthLocalStorage().saveToken(result.accessToken!);

          emit(LoginLoaded(responseModel: result));
        }
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });
  }
}
