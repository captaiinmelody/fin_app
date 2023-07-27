part of 'root_bloc.dart';

abstract class RootEvent {}

class HomeEvent extends RootEvent {}

class ProfileEvent extends RootEvent {}

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
