import 'package:flutter/foundation.dart';

enum Status {
  Connected,
  Disconnected,
  Idle,
}

enum DeviceState {
  Loaded,
  Refreshing,
  Downloading
}

class Sensor {
  final String id;
  final Status status;
  String name;
  final String iconPath;
  final List<DateTime> logs;
  DeviceState state;

  Sensor({
    @required this.id,
    @required this.status,
    @required this.name,
    @required this.iconPath,
    this.logs = const[],
    this.state = DeviceState.Loaded,
  });
}
