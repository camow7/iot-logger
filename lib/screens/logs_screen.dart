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
                SensorItem(sensor),
                SubCard(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Past Logs'),
                      const SizedBox(width: 5),
                      SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return LogItem(sensor: sensor, log: sensor.logs[index]);
                    },
                    itemCount: sensor.logs.length,
                    padding: const EdgeInsets.only(top: 10),
                  ),
                ),
              ],
            ),
            RefreshButton(refreshLogs)
          ],
        ),
      ),
    );
  }
}
