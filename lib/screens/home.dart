import 'package:flutter/material.dart';
import 'package:iot_logger/widgets/refresh_button.dart';

import '../models/sensor.dart';

import '../widgets/layout.dart';
import '../widgets/sensor_item.dart';

class Home extends StatelessWidget {
  final List<Sensor> sensors = [
    Sensor(
      id: '1',
      name: 'Water Tank',
      status: Status.Connected,
      iconPath: 'plug',
      logs: [DateTime.now(), DateTime.now()]
    ),
    Sensor(
      id: '2',
      name: 'Sewerage',
      status: Status.Idle,
      iconPath: 'plug',
    ),
    Sensor(
      id: '3',
      name: 'Pump',
      status: Status.Disconnected,
      iconPath: 'plug',
      state: DeviceState.Refreshing
    ),
    Sensor(
      id: '4',
      name: 'Air Con',
      status: Status.Connected,
      iconPath: 'download-light',
      state: DeviceState.Downloading
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        Column(
          children: [
            Column(
              children: sensors.map((sensor) => SensorItem(sensor)).toList(),
            ),
            RefreshButton(),
          ],
        ),
      ),
    );
  }
}
