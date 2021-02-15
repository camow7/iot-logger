import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import '../shared/layout.dart';
import '../widgets/log_item.dart';
import '../shared/sub_card.dart';
import '../widgets/sensor_item.dart';

class LogsScreen extends StatelessWidget {
  refreshLogs() {
    print('refreshing logs');
  }

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
                SubCard(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Past Logs'),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                  ],
                )),
                Column(
                  children: sensor.logs.map((log) {
                    return LogItem(sensor: sensor, log: log);
                  }).toList(),
                )
              ],
            ),
            RefreshButton(refreshLogs)
          ],
        ),
      ),
    );
  }
}
