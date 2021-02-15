import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import '../shared/layout.dart';
import '../widgets/reading_item.dart';
import '../widgets/sensor_item.dart';

class ReadingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BackButton(),
                SensorItem(sensor: sensor, progress: 0),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed('/graph-reading', arguments: sensor),
                  borderRadius: BorderRadius.circular(4),
                  child: ReadingItem(),
                )
              ],
            ),
            RefreshButton(null)
          ],
        ),
      ),
    );
  }
}
