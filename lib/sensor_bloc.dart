import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/shared/rive_animation.dart';

import './models/sensor.dart';

class SensorCubit extends Cubit<DeviceState> {
  SensorCubit() : super(DeviceState.Loaded);

  void reload() {
    emit(DeviceState.Refreshing);
    new Timer(new Duration(seconds: 5), () {
      print('5 secs');
      emit(DeviceState.Loaded);
    });
  }
}

List<Log> _createLogs() {
  List<Log> logList = [];
  for (var i = 0; i < 2; i++) {
    Log logItem = new Log(
        date: DateTime.now(),
        logId: (i + 1).toString(),
        progress: 0.0,
        logState: LogState.Loaded,
        icon: SvgPicture.asset(
          'assets/svgs/download.svg',
        ));
    logList.add(logItem);
  }
  return logList;
}

class LogsCubit extends Cubit<List<Log>> {
  LogsCubit() : super(_createLogs());

  /// Increments loading bar progress by 20%
  double _increment(val) {
    val += 0.2;
    return val;
  }

  /// Sets a log's state to [LogState.Downloading] with an animation and increments [LinearProgressIndicator] to simulate a download
  void download(int index) {
      state[index] = new Log(
        logId: state[index].logId,
        date: state[index].date,
        progress: _increment(state[index].progress),
        logState: LogState.Downloading,
        icon: RiveAnimation(),
      );
    _updateLogs();
  }

  void complete(int index) {
    state[index].progress = 0.0;
    state[index].logState = LogState.Downloaded;
    state[index].icon = Icon(Icons.done);
    _updateLogs();
  }

  /// Emits new changes to state's objects and refreshes UI list.
  ///
  /// Doing `emit(state)` alone in the [download] and [complete] methods were not updating UI
  /// probably due to Lists being MUTABLE and because "[emit] does nothing if the [state] being emitted is equal to the current [state]".
  void _updateLogs() {
    print('updating logs');
    List<Log> allLogs = [];
    allLogs.addAll(state);
    emit(allLogs);
  }
}
