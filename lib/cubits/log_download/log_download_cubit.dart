import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/services/arduino_repository.dart';
import 'package:meta/meta.dart';

import '../../services/download_service.dart';
import '../../models/sensor.dart';
import '../../shared/rive_animation.dart';

part 'log_download_state.dart';

class LogDownloadCubit extends Cubit<LogDownloadState> {
  StreamSubscription fileStreamSubscription;
  ArduinoRepository arduinoRepository;
  LogDownloadCubit(this.arduinoRepository)
      : super(
          LogInitial(
            progress: 0.0,
            status: LogStatus.Loaded, // Initial Non-Downloaded State
            icon: SvgPicture.asset(
              'assets/svgs/download.svg',
            ),
          ),
        );

  void downloadFile(String fileName) {
    arduinoRepository.getLogFile(fileName);

    fileStreamSubscription = arduinoRepository.fileStream.listen((percentage) {
      print("Download: " + percentage.toString());

      if (percentage < 1.0) {
        emit(
          LogDownloading(
            progress: percentage,
            status: LogStatus.Downloading,
            icon: RiveAnimation(),
          ),
        );
      } else {
        emit(
          LogDownloaded(
            progress: 0.0,
            status: LogStatus.Downloaded,
            icon: Icon(Icons.done_outline),
          ),
        );
        fileStreamSubscription.cancel();
      }
    });
  }
}
