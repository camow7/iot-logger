import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

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

class LogCubit extends Cubit<LogDownloadState> {
  LogCubit()
      : super(new LogDownloadState(
          progress: 0.0,
          logState: LogState.Loaded,
        ));

  @override
  LogDownloadState get state => super.state;

  /// Increments loading bar progress by 20%
  double increment(val) {
    val += 0.2;
    return val;
  }

  void download() {
    emit(
      new LogDownloadState(
        progress: increment(state.progress),
        logState: LogState.Downloading,
      ),
    );
    if (state.progress < 1) {
      new Timer(new Duration(seconds: 2), () {
        download();
      });
    }
  }

  void complete() {
    emit(
      new LogDownloadState(
        progress: 0.0,
        logState: LogState.Downloaded,
      ),
    );
  }
}
