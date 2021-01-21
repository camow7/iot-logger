import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'models/sensor.dart';

import 'sensor_item.dart';

class HomeScreen extends StatelessWidget {
  final List<Sensor> sensors = [
    Sensor(
      id: '1',
      name: 'Water Tank',
      status: Status.Connected,
      iconPath: 'plug',
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
    ),
    Sensor(
      id: '4',
      name: 'Air Con',
      status: Status.Connected,
      iconPath: 'download-light',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('SAPHI'),
          title: Image.asset('assets/images/trans-logo-landscape-white-text.png'),
        ),
        body: Column(
          children: sensors.map((sensor) => SensorItem(sensor)).toList(),
        ));
  }
}
