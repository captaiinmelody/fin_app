import 'package:fin_app/features/auth/data/dataresources/auth_datasources.dart';
import 'package:fin_app/features/auth/data/dataresources/product_datasources.dart';
import 'package:fin_app/features/auth/data/localresources/auth_local_storage.dart';
import 'package:fin_app/features/auth/data/models/response/product_response_model.dart';
import 'package:fin_app/features/auth/data/models/response/profile_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthDataSources authDataSources;
  final ProductDataSources? productDataSources;

  ProfileBloc(this.authDataSources, {this.productDataSources})
      : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      try {
        emit(ProfileLoading());
        final result = await authDataSources.getProfile();
        final product = await productDataSources!.getAllProduct();
        await AuthLocalStorage().getToken();
        emit(ProfileLoaded(
            profileResponseModel: result, productResponseModel: product));
      } catch (e) {
        emit(ProfileError(message: "Error ${e.toString()}"));
      }
    });
  }
}
