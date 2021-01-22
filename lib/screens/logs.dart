import 'package:flutter/material.dart';

import '../models/sensor.dart';

import '../widgets/layout.dart';
import '../widgets/sensor_item.dart';

class Logs extends StatelessWidget {
  final Sensor sensor;

  const Logs(this.sensor);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(SensorItem(sensor)),
    );
  }
}