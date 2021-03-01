import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/services/arduino_repository.dart';
import 'package:meta/meta.dart';
import '../../models/sensor.dart';
import '../../shared/rive_animation.dart';
import 'package:async/async.dart';

part 'log_download_state.dart';

class LogDownloadCubit extends Cubit<LogDownloadState> {
  StreamSubscription fileStreamSubscription;
  ArduinoRepository arduinoRepository;
  RestartableTimer timeoutTimer;

  LogDownloadCubit(this.arduinoRepository)
      : super(
          LogLoaded(
            progress: 0.0,
            status: LogStatus.Loaded, // Initial Non-Downloaded State
            icon: SvgPicture.asset(
              'assets/svgs/download.svg',
            ),
          ),
        );

  void downloadFile(String fileName) {
    arduinoRepository.getLogFile(fileName);

    // Start connection timer
    timeoutTimer = new RestartableTimer(Duration(seconds: 2), () {
      print("Message not received timed out");
      stopDownload();
    });

    fileStreamSubscription =
        arduinoRepository.fileStream.listen((double percentage) {
      timeoutTimer.reset();
      print("Download: " + percentage.toString());

      if (percentage < 1.0) {
        emit(LogDownloading(progress: percentage));
      } else {
        timeoutTimer.cancel();
        emit(LogDownloaded());
        fileStreamSubscription.cancel();
      }
    });
  }

  void stopDownload() {
    emit(LogDownloaded());
    arduinoRepository.writeMessageToFile();
    fileStreamSubscription.cancel();
  }
}
