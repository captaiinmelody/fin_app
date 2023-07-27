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
  final List<ReportsModels>? reportsModels;
  LoadedState({
    this.response,
    this.reportsModels,
  });
}

class ErrorState extends RootState {
  final String message;
  ErrorState({
    required this.message,
  });
}