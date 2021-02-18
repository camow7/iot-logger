import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class HomeScreen extends StatelessWidget {
  final Sensor sensor = Sensor(
      id: '1',
      name: 'Sensor 1',
      status: DeviceStatus.Connected,
      logs: [
        Log(
            date: DateTime.now(),
            logId: '1',
            progress: 0.0,
            logState: LogStatus.Loaded,
            readings: [
              Reading('Turb 1'),
              Reading('Turb 2'),
              Reading('Turb 3'),
              Reading('Temp'),
            ]),
        Log(
          date: DateTime.now(),
          logId: '2',
          progress: 0.0,
          logState: LogStatus.Loaded,
        ),
        Log(
          date: DateTime.now(),
          logId: '2',
          progress: 0.0,
          logState: LogStatus.Loaded,
        ),
        Log(
          date: DateTime.now(),
          logId: '2',
          progress: 0.0,
          logState: LogStatus.Loaded,
        ),
        Log(
          date: DateTime.now(),
          logId: '2',
          progress: 0.0,
          logState: LogStatus.Loaded,
        ),
        Log(
          date: DateTime.now(),
          logId: '2',
          progress: 0.0,
          logState: LogStatus.Loaded,
        ),
      ]);

  void refreshPage() {
    print('homepage refresh');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Sensor',
              style: Theme.of(context).textTheme.headline1,
            ),
            SensorItem(sensor),
            RefreshButton(refreshPage),
          ],
        ),
      ),
    );
  }
}
