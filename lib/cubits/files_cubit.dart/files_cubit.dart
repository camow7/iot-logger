import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final ArduinoRepository _arduinoRepository;
  StreamSubscription<List<String>> _fileNamesStreamSubscription;
  List<String> fileNames;

  FilesCubit(
    this._arduinoRepository,
  ) : super(LoadingFiles());

  void getFiles() {
    print("get files triggered");
    _arduinoRepository.getLogsList();
    _fileNamesStreamSubscription =
        _arduinoRepository.fileNamesStream.listen((data) {
      fileNames = data;
      if (fileNames.length == 0) {
        emit(NoFiles());
      } else {
        //print(fileNames);
        emit(Files(fileNames: fileNames));
      }
    });
  }
}
