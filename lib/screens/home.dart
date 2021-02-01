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
        logs: [DateTime.now(), DateTime.now()]),
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
      state: DeviceState.Connecting,
    ),
    Sensor(
      id: '4',
      name: 'Air Con',
      status: Status.Connected,
      iconPath: 'download-light',
      // state: DeviceState.Downloading,
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
            // RefreshButton(),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text(
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
