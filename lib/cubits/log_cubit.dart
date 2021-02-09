import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/sensor.dart';

class LogCubit extends Cubit<Log> {
  final Log log;
  LogCubit(this.log) : super(log);

  /// Increments loading bar progress by 20%
  double _increment(val) {
    val += 0.2;
    return val;
  }

  /// Sets a log's state to [LogState.Downloading] with an animation and increments [LinearProgressIndicator] to simulate a download
  void download() {
    log.progress = _increment(log.progress);
    log.logState = LogState.Downloading;
    _updateState();
  }

  void complete() {
    log.progress = 0.0;
    log.logState = LogState.Downloaded;
    _updateState();
  }

  /// Emits new changes to a log object in a new log object to refresh the UI
  void _updateState() {
    emit(
      Log(
        date: log.date,
        logId: log.logId,
        progress: log.progress,
        logState: log.logState,
      ),
    );
  }
}
