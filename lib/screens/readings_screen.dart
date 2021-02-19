import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import '../shared/layout.dart';
import '../widgets/reading_item.dart';
import '../widgets/sensor_item.dart';

class ReadingsScreen extends StatelessWidget {
  void refreshPage() {
    print('refreshing readings screen');
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Layout(
      content: isLandscape
          ? SingleChildScrollView(child: pageContent(context, isLandscape))
          : pageContent(context, isLandscape),
    );
  }

  Widget pageContent(BuildContext context, bool isLandscape) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<Object, Object>;
    final sensor = routeArgs['sensor'] as Sensor;
    final readings = routeArgs['readings'] as List<Reading>;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            BackButton(),
            SensorItem(sensor),
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              child: readings.length > 0
                  ? GridView(
                      padding: EdgeInsets.only(top: 10),
                      children: readings
                          .map((reading) => ReadingItem(reading.name))
                          .toList(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: isLandscape ? 5.5 : 4.5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                        maxCrossAxisExtent: 500,
                      ),
                    )
                  : Text('No readings'),
            ),
          ],
        ),
        RefreshButton(refreshPage)
      ],
    );
  }
}
