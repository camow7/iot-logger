import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final ArduinoRepository _arduinoRepository;
  StreamSubscription fileNameStreamSubscription;
  List<String> fileNames = [];

  FilesCubit(
    this._arduinoRepository,
  ) : super(LoadingFiles());

  void getFiles() {
    _arduinoRepository.getLogsList();

    fileNameStreamSubscription =
        _arduinoRepository.fileNamesStream.listen((List<String> files) {
      fileNames = files;
      emit(Files(fileNames: fileNames));
    });
  }
}
