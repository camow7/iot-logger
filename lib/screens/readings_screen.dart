import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import '../shared/layout.dart';
import '../widgets/reading_item.dart';
import '../widgets/sensor_item.dart';

class ReadingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<Object, Object>;
    final sensor = routeArgs['sensor'] as Sensor;
    final readings = routeArgs['readings'] as List<Reading>;
    // print(sensor);
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BackButton(),
                SensorItem(sensor: sensor, progress: 0),
                Column(
                  children: readings
                      .map(
                        (reading) => InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/graph-reading', arguments: reading.name),
                          borderRadius: BorderRadius.circular(4),
                          child: ReadingItem(reading.name),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            RefreshButton(null)
          ],
        ),
      ),
    );
  }
}
