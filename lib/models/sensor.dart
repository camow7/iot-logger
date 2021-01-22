import 'package:flutter/foundation.dart';

enum Status {
  Connected,
  Disconnected,
  Idle,
}

class Sensor {
  final String id;
  final Status status;
  final String name;
  final String iconPath;
  final List<DateTime> logs;

  Sensor({
    @required this.id,
    @required this.status,
    @required this.name,
    @required this.iconPath,
    this.logs = const[],
  });
}
