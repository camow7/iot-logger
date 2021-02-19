import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import '../shared/layout.dart';
import '../widgets/log_item.dart';
import '../shared/sub_card.dart';
import '../widgets/sensor_item.dart';

class LogsScreen extends StatelessWidget {
  refreshPage() {
    print('refreshing logs');
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Layout(
      content: isLandscape
          ? SingleChildScrollView(child: pageContent(context))
          : pageContent(context),
    );
  }

  Widget pageContent(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Column(
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
                  const Text('Past Logs',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                  const SizedBox(width: 5),
                  SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GridView(
                padding: EdgeInsets.only(top: 10),
                children: sensor.logs
                    .map(
                      (log) => LogItem(sensor: sensor, log: log),
                    )
                    .toList(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 5.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  maxCrossAxisExtent: 500,
                ),
              ),
            ),
          ],
        ),
        RefreshButton(refreshPage)
      ],
    );
  }
}
