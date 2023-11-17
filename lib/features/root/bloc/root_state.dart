part of 'root_bloc.dart';

@immutable
abstract class RootState {}

class InitialState extends RootState {}

class HomeState extends RootState {
  final bool isLoading, isError;
  final List<ReportsModel>? reportsData;
  final String? message;
  HomeState({
    required this.isLoading,
    required this.isError,
    this.reportsData,
    this.message,
  });
}

class ReportsState extends RootState {
  final bool isLoading, isError;
  final List<ReportsModel>? reportsData;
  final String? message;
  final ButtonState? buttonState;
  ReportsState({
    required this.isLoading,
    required this.isError,
    this.reportsData,
    this.message,
    this.buttonState,
  });
}

class ProfileState extends RootState {
  final UserModel? userResponseModels;
  final bool isLoading, isError;
  final String? message;
  ProfileState({
    this.userResponseModels,
    required this.isLoading,
    required this.isError,
    this.message,
  });
}

class CreateReportsState extends RootState {
  final bool isLoading, isError;
  final String? message;
  CreateReportsState({
    required this.isLoading,
    required this.isError,
    this.message,
  });
}

class ReportsDetailState extends RootState {
  final ReportsModel reportsModel;
  ReportsDetailState(this.reportsModel);
}

class NotificationState extends RootState {
  final bool isLoading, isError;
  final String? message;
  final List<NotificationModels>? listNotification;
  NotificationState({
    required this.isLoading,
    required this.isError,
    this.message,
    this.listNotification,
  });
}

class NotificationDetailLoadedState extends RootState {
  NotificationDetailLoadedState(this.reportsModel);
  final ReportsModel? reportsModel;
}

class ButtonState extends RootState {
  final bool isLoading, isError, isClicked;
  final String? message, status;
  ButtonState({
    required this.isLoading,
    required this.isError,
    required this.isClicked,
    this.message,
    this.status,
  });
}
