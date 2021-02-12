import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../widgets/log_items.dart';
import '../widgets/sensor_item.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Scaffold(
      body: Layout(
        Column(
          children: [
            SensorItem(sensor: sensor, progress: 0),
            Card(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Past Logs'),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                  ],
                ),
              ),
            ),
            Column(
              children: sensor.logs.map((log) {
                return LogItems(log);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
