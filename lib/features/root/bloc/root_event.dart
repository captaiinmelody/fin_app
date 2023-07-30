part of 'root_bloc.dart';

abstract class RootEvent {}

class HomeEvent extends RootEvent {}

class ProfileEventGetUser extends RootEvent {}

//reports event
class ReportsEventPost extends RootEvent {
  final String? description;
  final File? imageFiles;
  final File? videoFiles;
  final String? kampus;
  final String? detailLokasi;
  ReportsEventPost({
    this.description,
    this.imageFiles,
    this.videoFiles,
    this.kampus,
    this.detailLokasi,
  });
}

class ReportsEventGet extends RootEvent {}

class ReportsEventGetByUserId extends RootEvent {}

class ReportsEventUpdateCounter extends RootEvent {
  final String? reportsId;
  final String? counter;
  ReportsEventUpdateCounter({
    this.reportsId,
    this.counter,
  });
}

class LeaderboardsEvent extends RootEvent {}

class LeaderboardsEventGetByUserId extends RootEvent {}
