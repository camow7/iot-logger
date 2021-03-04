import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/models/Messages.dart';
import 'package:iot_logger/services/arduino_repository.dart';
import 'package:meta/meta.dart';
import '../../models/sensor.dart';
import '../../shared/rive_animation.dart';
import 'package:async/async.dart';

part 'log_download_state.dart';

class LogDownloadCubit extends Cubit<LogDownloadState> {
  ArduinoRepository arduinoRepository;
  RestartableTimer timeoutTimer;
  MessageFile currentfile;

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

  Future<MessageFile> getIndexedFile(String fileName) async {
    MessageFile file;
    arduinoRepository.getLogFile(fileName);

    await for (MessageFile tempFile in arduinoRepository.fileStream
        .timeout(Duration(seconds: 2), onTimeout: (stream) {
      print("Message timed out");
      stream.close();
      return file;
    })) {
      file = tempFile;
      if (file.percentage == 1.0) {
        break;
      }
    }

    return file;
  }

  void downloadFile(String fileName) async {
    print("Download Log file");
    int count = 0;
    bool fileIsComplete = false;
    print("Waiting for log file");

    // First Attempt of getting file
    MessageFile file = await getIndexedFile(fileName);

    print("log file returned ");
    count++;

    if (file.percentage == 1.0) {
      fileIsComplete = true;
      print("file was complete");
      for (int i = 0; i < file.file.length; i++) {
        print(i.toString() +
            " Elements: " +
            String.fromCharCodes(file.file[i]).split(",").length.toString() +
            " " +
            String.fromCharCodes(file.file[i]));
      }
    }

    // Second to Fith Attempt of getting file
    while (count < 5 && fileIsComplete != true) {
      print("Download Attempt: $count");
      MessageFile tempFile = await getIndexedFile(fileName);

      if (tempFile.percentage == 1.0) {
        file = tempFile;
        fileIsComplete = true;
        for (int i = 0; i < file.file.length; i++) {
          print(i.toString() +
              " Elements: " +
              String.fromCharCodes(file.file[i]).split(",").length.toString() +
              " " +
              String.fromCharCodes(file.file[i]));
        }
      } else {
        // merge file and temp file then check for completeness
      }
      count++;
    }

    print("EMITTING LOG DOWNLAODED");
    emit(LogDownloaded());
    // arduinoRepository.writeMessageToFile();
    // write file to disk
  }

  void stopDownload() {
    emit(LogDownloaded());
    arduinoRepository.writeMessageToFile();
  }
}
