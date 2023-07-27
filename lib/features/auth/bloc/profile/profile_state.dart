// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileResponseModel profileResponseModel;
  final List<ProductResponseModel>? productResponseModel;
  ProfileLoaded({
    this.productResponseModel,
    required this.profileResponseModel,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({
    required this.message,
  });
}
