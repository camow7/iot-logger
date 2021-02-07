import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import './models/sensor.dart';

enum LogEvent { downloading, completeDownload }
enum SensorEvent { refresh }

/// Increments loading bar progress by 20%
double increment(val) {
  val += 0.2;
  return val;
}

/// Changes the state of a log item's download state
class LogBloc extends Bloc<LogEvent, LogDownloadState> {
  LogBloc()
      : super(new LogDownloadState(
          progress: 0.0,
          logState: LogState.Loaded,
        ));

  @override
  Stream<LogDownloadState> mapEventToState(LogEvent event) async* {
    switch (event) {
      case LogEvent.downloading:
        while (state.progress < 1) {
          // set this to < 0.5, to see spinner as if LogState.downloading was still in progress
          // simulate download bar
          var val = new LogDownloadState(
            progress: increment(state.progress),
            logState: LogState.Downloading,
          );
          yield val;
          print('${val.progress}, ${val.logState}');
        }
        break;
      case LogEvent.completeDownload:
        var val = new LogDownloadState(
          progress: 0.0,
          logState: LogState.Downloaded,
        );
        yield val;
        print('Download complete, must refresh again to re-download (wip)');
        print('${val.progress}, ${val.logState}');
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}

class SensorCubit extends Cubit<DeviceState> {
  SensorCubit() : super(DeviceState.Loaded);

  /// Add 1 to the current state.
  void reload() {
    emit(DeviceState.Refreshing);
    new Timer(new Duration(seconds: 5), () {
      print('5 secs');
      emit(DeviceState.Loaded);
    });
  }
}
