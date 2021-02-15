import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class HomeScreen extends StatelessWidget {
  final Sensor sensor = Sensor(
      id: '1',
      name: 'Water Tank',
      status: Status.Connected,
      iconPath: 'plug',
      logs: [
        Log(
          date: DateTime.now(),
          logId: '1',
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Sensor',
              style: Theme.of(context).textTheme.headline1,
            ),
            SensorItem(
              sensor: sensor,
              progress: 0,
            ),
            RefreshButton(refreshPage),
          ],
        ),
      ),
    );
  }
}
