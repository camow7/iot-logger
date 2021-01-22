import 'package:flutter/material.dart';

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

  void refresh() {
    print('refresh sensors');
  }

  Widget val() {
    return Column(
      children: [
        Column(
          children: sensors.map((sensor) => SensorItem(sensor)).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: () => refresh(),
          child: const Text(
            'Refresh',
            style: TextStyle(color: Colors.white),
          ),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(40),
          elevation: 3,
          color: const Color.fromRGBO(108, 194, 130, 1),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        Column(
          children: [
            Column(
              children: sensors.map((sensor) => SensorItem(sensor)).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () => refresh(),
              child: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(40),
              elevation: 3,
              color: const Color.fromRGBO(108, 194, 130, 1),
            )
          ],
        ),
      ),
    );
  }
}
