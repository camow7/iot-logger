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

  Sensor({
    @required this.id,
    @required this.status,
    @required this.name,
    @required this.iconPath,
  });
}
