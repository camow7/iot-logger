import 'package:flutter/material.dart';

import '../models/sensor.dart';

import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class Logs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Scaffold(
      body: Layout(Column(
        children: [
          SensorItem(sensor),
          RefreshButton(),
        ],
      )),
    );
  }
}
