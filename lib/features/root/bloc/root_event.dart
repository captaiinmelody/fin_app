part of 'root_bloc.dart';

abstract class RootEvent {}

class GetProfileEvent extends RootEvent {}

class GetReportsEvent extends RootEvent {
  final String page, role;
  final String? campus, reportsId;
  GetReportsEvent(
    this.role,
    this.page, {
    this.campus,
    this.reportsId,
  });
}

class CreateReportsEvent extends RootEvent {
  final String? description, kampus, detailLokasi;
  final List<File?>? imageFiles;
  final File? videoFiles;
  CreateReportsEvent({
    this.description,
    this.kampus,
    this.detailLokasi,
    this.imageFiles,
    this.videoFiles,
  });
}

class ConfirmingReportsEvent extends RootEvent {
  final String reportsId, status, targetRole;
  ConfirmingReportsEvent(
    this.reportsId,
    this.status,
    this.targetRole,
  );
}

class DeleteReportsEvent extends RootEvent {
  final String reportsId;
  DeleteReportsEvent(this.reportsId);
}

class ConfirmingFixingEvent extends RootEvent {
  final MediaUrl? mediaUrl;
  final String reportsId;
  final String? description;
  final List<File?>? imageFiles;
  final File? videoFiles;
  ConfirmingFixingEvent(
      {this.mediaUrl,
      required this.reportsId,
      this.description,
      this.imageFiles,
      this.videoFiles});
}

class ButtonEvent extends RootEvent {
  final bool? isClicked;
  ButtonEvent(this.isClicked);
}

class GetReportsDetailEvent extends RootEvent {
  final String reportsId;
  GetReportsDetailEvent(this.reportsId);
}

class GetNotificationHistoryEvent extends RootEvent {
  final String userId;
  GetNotificationHistoryEvent(this.userId);
}
