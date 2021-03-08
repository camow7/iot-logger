import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';

import 'package:flutter/foundation.dart';
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
  int currentPercentage = 0;

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
      } else {
        emit(LogDownloading(progress: file.percentage));
      }
    }

    return file;
  }

  void downloadFile(String fileName) async {
    int count = 0;
    List<String> newList = [];
    int newListSize = 0;
    bool fileIsComplete = false;
    print("Waiting for log file");

    // First Attempt of getting the file
    MessageFile file = await getIndexedFile(fileName);
    print("log file returned ");
    print("List Size: ${file.list.length}");

    // Check for Success
    if (file.percentage == 1.0) {
      fileIsComplete = true;
      print("file is complete");
    }

    // Re-attempt to get file 4 more times
    while (count < 4 && fileIsComplete != true) {
      print("Download Attempt: $count");
      MessageFile tempFile = await getIndexedFile(fileName);

      // Check for success
      if (tempFile.percentage == 1.0) {
        print("temp file completed");
        file = tempFile;
        fileIsComplete = true;
      } else {
        print("merging files.....");
        // Otherwise merge attempts
        if (count == 0) {
          newList = [
            ...tempFile.list,
            ...file.list,
          ].toSet().toList();
        } else {
          newList = [...tempFile.list, ...newList].toSet().toList();
        }

        // Calculate size of merged attempt

        for (int i = 0; i < newList.length; i++) {
          newListSize += Uint8List.fromList(newList[0].codeUnits).lengthInBytes;
        }

        print(
            "New List Size: ${newList.length} = ${(newListSize / arduinoRepository.fileSize).toString()}%");

        // Check for Success
        if (newListSize == arduinoRepository.fileSize) {
          print("temp file merged successfully");
          file = MessageFile(1.0, newList);
          fileIsComplete = true;
        }
      }
      count++;
    }

    for (int i = 0; i < file.list.length; i++) {
      print(i.toString() + " " + file.list[i]);
    }

    print("EMITTING RESULT");
    emit(LogDownloaded());
    arduinoRepository.writeListToFile(file.list);
  }

  void stopDownload() {
    emit(LogDownloaded());
    // arduinoRepository.writeMessageToFile();
  }

  int percentage(int newPercentage) {
    if (newPercentage > currentPercentage) {
      currentPercentage = newPercentage;
      return newPercentage;
    } else
      return currentPercentage;
  }
}
