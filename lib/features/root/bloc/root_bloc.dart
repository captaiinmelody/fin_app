import 'dart:io';

import 'package:fin_app/features/auth/data/models/user_model.dart';
import 'package:fin_app/features/root/data/datasources/notification_sources.dart';
import 'package:fin_app/features/root/data/datasources/profile_sources.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/data/models/notification_models.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  ReportsRepository? reportsRepository;
  ProfileDataSources? profileDataSources;
  NotificationSources? notificationSources;

  RootBloc({
    this.reportsRepository,
    this.profileDataSources,
    this.notificationSources,
  }) : super(InitialState()) {
    on<ConfirmingReportsEvent>((event, emit) async {
      emit(ButtonState(isLoading: true, isError: false, isClicked: false));
      try {
        final status = await reportsRepository!.reportsConfirmation(
          event.reportsId,
          event.status,
          event.targetRole,
        );

        emit(ButtonState(
          isLoading: false,
          isError: false,
          isClicked: true,
          status: status,
        ));
      } catch (e) {
        print(e.toString());
        emit(ButtonState(
            isLoading: false,
            isError: true,
            isClicked: true,
            message: e.toString()));
      }
    });

    on<DeleteReportsEvent>((event, emit) async {
      emit(ButtonState(isLoading: true, isError: false, isClicked: false));
      try {
        final message = await reportsRepository!.deleteReports(event.reportsId);
        emit(ButtonState(
          isLoading: false,
          isError: false,
          isClicked: false,
          message: message,
        ));
      } catch (e) {
        emit(
          ButtonState(
            isLoading: false,
            isError: true,
            isClicked: false,
            message: e.toString(),
          ),
        );
      }
    });

    on<ConfirmingFixingEvent>((event, emit) async {
      emit(CreateReportsState(isLoading: true, isError: false));
      try {
        List<String> missingFields = [];
        if (event.description == null || event.description == '') {
          missingFields.add("Deskripsi");
        }
        if (event.imageFiles == null && event.videoFiles == null) {
          missingFields.add("Gambar atau video");
        }
        String combinedMessage = "${missingFields.join(", ")} harus diisi";
        if (event.description != '') {
          if ((event.imageFiles != null && event.videoFiles == null) ||
              (event.imageFiles == null && event.videoFiles != null) ||
              (event.imageFiles != null && event.videoFiles != null)) {
            final response = await reportsRepository!.reportsFixConfirmation(
                event.description,
                event.imageFiles,
                event.videoFiles,
                event.reportsId);
            emit(CreateReportsState(
              isLoading: false,
              isError: false,
              message: response,
            ));
          }
        } else {
          emit(CreateReportsState(
            isLoading: false,
            isError: true,
            message: combinedMessage,
          ));
        }
      } catch (e) {
        emit(CreateReportsState(
          isLoading: false,
          isError: true,
          message: e.toString(),
        ));
      }
    });

    on<CreateReportsEvent>((event, emit) async {
      emit(CreateReportsState(isLoading: true, isError: false));

      try {
        List<String> missingFields = [];
        if (event.description == null || event.description == '') {
          missingFields.add("Deskripsi");
        }
        if (event.imageFiles == null && event.videoFiles == null) {
          missingFields.add("Gambar atau video");
        }
        if (event.kampus == null) {
          missingFields.add("Kampus");
        }
        if (event.detailLokasi == null || event.detailLokasi == '') {
          missingFields.add("Detail Lokasi");
        }
        String combinedMessage = "${missingFields.join(", ")} harus diisi";
        if (event.description != '' &&
            event.detailLokasi != '' &&
            event.kampus != null &&
            event.detailLokasi != '') {
          if ((event.imageFiles != null && event.videoFiles == null) ||
              (event.imageFiles == null && event.videoFiles != null) ||
              (event.imageFiles != null && event.videoFiles != null)) {
            final res = await reportsRepository!.postReports(
              event.description,
              event.imageFiles,
              event.videoFiles,
              event.kampus,
              event.detailLokasi,
            );
            emit(CreateReportsState(
              isLoading: false,
              isError: false,
              message: res,
            ));
          }
        } else {
          emit(CreateReportsState(
            isLoading: false,
            isError: true,
            message: combinedMessage,
          ));
        }
      } catch (e) {
        emit(
          CreateReportsState(
            isLoading: false,
            isError: true,
            message: e.toString(),
          ),
        );
      }
    });

    on<GetReportsEvent>(((event, emit) async {
      if (event.page == "home") {
        emit(HomeState(isLoading: true, isError: false));
      } else {
        emit(ReportsState(isLoading: true, isError: false));
      }
      try {
        if (event.role == "all") {
          final response = await reportsRepository!.getAllReports();
          emit(HomeState(
              isLoading: false, isError: false, reportsData: response));
          return;
        } else if (event.role == "admin") {
          final res = await reportsRepository!.getAllReports();
          emit(ReportsState(
            isLoading: false,
            isError: false,
            reportsData: res,
          ));
          return;
        } else if (event.role == "reporter") {
          final res = await reportsRepository!.getReportsByReporterId();
          emit(
              ReportsState(isLoading: false, isError: false, reportsData: res));
          return;
        } else if (event.role.startsWith("krt")) {
          final res =
              await reportsRepository!.getReportsByCampus(event.campus!);
          emit(
              ReportsState(isLoading: false, isError: false, reportsData: res));
        } else {
          final res =
              await reportsRepository!.getReportsDetail(event.reportsId);
          emit(ReportsDetailState(res));
        }
      } catch (e) {
        if (event.page == "home") {
          HomeState(isLoading: false, isError: true, message: e.toString());
        } else {
          ReportsState(isLoading: false, isError: true, message: e.toString());
        }
      }
    }));

    // on<GetReportsDetailEvent>((event, emit) async {
    //   // emit(LoadingState());
    //   try {
    //     final res = await reportsDataSources!.getReportsDetail(event.reportsId);
    //     emit(ReportsDetailState(res));
    //   } catch (e) {
    //     print(e);
    //     emit(ErrorState(message: "Gagal melakukan pengambilan data"));
    //   }
    // });

    on<GetNotificationHistoryEvent>((event, emit) async {
      emit(NotificationState(isLoading: true, isError: false));
      try {
        final notificationHistory =
            await notificationSources!.getNotificationHistory(event.userId);

        emit(NotificationState(
          isLoading: false,
          isError: false,
          listNotification: notificationHistory,
        ));
      } catch (e) {
        emit(NotificationState(
          isLoading: false,
          isError: true,
          message: "error fetching data",
        ));
      }
    });

    on<GetProfileEvent>((event, emit) async {
      emit(ProfileState(isLoading: true, isError: false));
      try {
        final res = await profileDataSources!.fetchUserData();

        emit(ProfileState(
            isLoading: false, isError: false, userResponseModels: res));
      } catch (e) {
        emit(
          ProfileState(
            isLoading: false,
            isError: true,
            message: e.toString(),
          ),
        );
      }
    });
  }
}
