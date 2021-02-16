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
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BackButton(),
                SensorItem(sensor),
                Container(
                  height: 370,
                  child: readings != null
                      ? ListView.builder(
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  '/graph-reading',
                                  arguments: readings[index].name),
                              borderRadius: BorderRadius.circular(4),
                              child: ReadingItem(readings[index].name),
                            );
                          },
                          itemCount: readings.length,
                          padding: const EdgeInsets.only(top: 10),
                        )
                      : Text('No readings'),
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
