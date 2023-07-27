import 'dart:io';

import 'package:fin_app/features/firebase/auth/data/models/response/user_response_models.dart';
import 'package:fin_app/features/root/data/datasources/leaderboards_sources.dart';
import 'package:fin_app/features/root/data/datasources/report_sources.dart';
import 'package:fin_app/features/root/data/models/report_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  ReportsDataSources reportsDataSources;
  LeaderboardSources leaderboardSources;
  RootBloc(this.reportsDataSources, this.leaderboardSources)
      : super(InitialState()) {
    on<HomeEvent>((event, emit) {});
    on<ReportsEventPost>((event, emit) async {
      emit(LoadingState());

      try {
        List<String> missingFields = [];
        if (event.description == null || event.description == '') {
          missingFields.add("Description");
        }
        if (event.imageFiles == null && event.videoFiles == null) {
          missingFields.add("Image or video");
        }
        if (event.kampus == null) {
          missingFields.add("Campus");
        }
        if (event.detailLokasi == null || event.detailLokasi == '') {
          missingFields.add("Location detail");
        }
        String combinedMessage = "${missingFields.join(", ")} cannot be empty";

        if (event.description != '' &&
            event.detailLokasi != '' &&
            event.kampus != null &&
            event.detailLokasi != '') {
          if ((event.imageFiles != null && event.videoFiles == null) ||
              (event.imageFiles == null && event.videoFiles != null) ||
              (event.imageFiles != null && event.videoFiles != null)) {
            final response = await reportsDataSources.postReports(
              event.description,
              event.imageFiles,
              event.videoFiles,
              event.kampus,
              event.detailLokasi,
            );
            emit(LoadedState(response: response));
          }
        } else {
          emit(ErrorState(message: combinedMessage));
        }
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    });

    on<ReportsEventGet>(
      ((event, emit) async {
        emit(LoadingState());
        try {
          final result = await reportsDataSources.getReports();

          emit(LoadedState(reportsModels: result));
        } catch (e) {
          emit(ErrorState(message: e.toString()));
        }
      }),
    );

    on<ReportsEventGetByUserId>(((event, emit) async {
      emit(LoadingState());
      try {
        final result = await reportsDataSources.getReportsByUserId();

        emit(LoadedState(reportsModels: result));
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    }));

    on<LeaderboardsEvent>(
      ((event, emit) async {
        emit(LoadingState());

        try {
          final response = await leaderboardSources.getUsers();

          emit(LoadedState(userResponseModels: response));
        } catch (e) {
          emit(ErrorState(message: e.toString()));
        }
      }),
    );

    on<ProfileEvent>((event, emit) {});
  }
}
