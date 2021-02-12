import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meta/meta.dart';

import '../../services/download_service.dart';
import '../../models/sensor.dart';
import '../../shared/rive_animation.dart';

part 'log_download_state.dart';

class LogDownloadCubit extends Cubit<LogDownloadState> {
  DownloadService service = DownloadService();
  LogDownloadCubit()
      : super(
          LogInitial(
            progress: 0.0,
            status: LogStatus.Loaded,
            icon: SvgPicture.asset(
              'assets/svgs/download.svg',
            ),
          ),
        );

  void download() {
    service.downloadLog();
    emit(
      LogDownloading(
        progress: service.getProgress(),
        status: service.getStatus(),
        icon: RiveAnimation(),
      ),
    );
    if (service.getProgress() < 1) {
      new Timer(new Duration(seconds: 2), () {
        download();
      });
    } else {
      complete();
      close();
    }
  }

  void complete() => emit(
        LogDownloaded(
          progress: 0.0,
          status: LogStatus.Downloaded,
          icon: Icon(Icons.done_outline),
        ),
      );

  void view(String date) => emit(
        LogViewing(
          date: date,
          progress: 0.0,
          status: LogStatus.Viewing,
          icon: Container(),
        ),
      );
}
