part of 'root_bloc.dart';

@immutable
abstract class RootState {}

class InitialState extends RootState {}

class LoadingState extends RootState {
  final List<ReportsModels>? reportsModels;
  LoadingState({
    this.reportsModels,
  });
}

class ButtonLoadingState extends RootState {}

class ButtonLoadedState extends RootState {
  final bool? isClicked;
  ButtonLoadedState(this.isClicked);
}

class LoadedState extends RootState {
  final String? response;
  final List<ReportsModels>? listOfReportsModels;
  final ReportsModels? reportsModelsById;
  final int? counter;

  LoadedState({
    this.response,
    this.listOfReportsModels,
    this.reportsModelsById,
    this.counter,
  });
}

class LeaderboardsLoadedState extends RootState {
  final List<LeaderboardsModels>? listOfLeaderboardsModels;
  final LeaderboardsModels? leaderboardsModels;
  LeaderboardsLoadedState({
    this.listOfLeaderboardsModels,
    this.leaderboardsModels,
  });
}

class ProfileLoadedState extends RootState {
  final UserResponseModels? userResponseModels;

  ProfileLoadedState({
    this.userResponseModels,
  });
}

class AdminLoadedState extends RootState {
  final ReportsModels? reportsModels;
  AdminLoadedState({this.reportsModels});
}

class ErrorState extends RootState {
  final String message;
  ErrorState({
    required this.message,
  });
}
