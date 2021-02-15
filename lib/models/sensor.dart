import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status {
  Connected,
  Disconnected,
  Idle,
}
enum LogStatus {
  Loaded,
  Downloading,
  Downloaded,
  Viewing
}
enum DeviceState {
  Loaded,
  Refreshing,
  Refreshed,
}

class Sensor {
  final String id;
  final Status status;
  String name;
  final String iconPath;
  final List<Log> logs;
  DeviceState state;

  Sensor({
    @required this.id,
    @required this.status,
    @required this.name,
    @required this.iconPath,
    this.logs = const [],
    this.state = DeviceState.Loaded,
  });
}

/// `logState` is set to [LogState.Downloading] if progress bar has values >0 and <1.
/// Once `progress` reaches `1`, [LogState.Downloaded]. Otherwise [LogState.Loaded] once the logs of a sensor has been loaded.
class Log {
  final String logId;
  final DateTime date;
  double progress;
  LogStatus logState;
  List<Reading> readings;

  Log({
    @required this.logId,
    @required this.date,
    this.progress = 0.0,
    this.logState = LogStatus.Loaded,
    this.readings
  });
}

class Reading {
  final String name;

  const Reading(this.name);
}