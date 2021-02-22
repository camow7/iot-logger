import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Sensor',
              style: Theme.of(context).textTheme.headline1,
            ),
            SensorItem(),
            RefreshButton(),
          ],
        ),
      ),
    );
  }
}
