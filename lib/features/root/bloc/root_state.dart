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

class LoadedState extends RootState {
  final String? response;
  final List<ReportsModels>? listOfReportsModels;
  final int? counter;

  LoadedState({
    this.response,
    this.listOfReportsModels,
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

class ErrorState extends RootState {
  final String message;
  ErrorState({
    required this.message,
  });
}
