import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final ArduinoRepository _arduinoRepository;
  List<String> fileNames;

  FilesCubit(
    this._arduinoRepository,
  ) : super(LoadingFiles());

  void getFiles() async {
    // print("get files triggered");
    _arduinoRepository.getLogsList();
    fileNames = await _arduinoRepository.fileNamesController.stream.first;
    if (fileNames.length == 0) {
      emit(NoFiles());
    } else {
      emit(Files(fileNames: fileNames));
    }
  }
}
