import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../widgets/sensor_item.dart';
import '../widgets/log_items.dart';
import '../shared/refresh_button.dart';

class LogsScreen extends StatefulWidget {
  @override
  _LogsScreenState createState() => _LogsScreenState();
}

// This needs to be changed to Bloc!!!
class _LogsScreenState extends State<LogsScreen> {
  Sensor sensor;

  // refresh to obtain logs
  void refresh() {
    setState(() {
      sensor.state = sensor.state == DeviceState.Loaded
          ? DeviceState.Refreshing
          : DeviceState.Loaded;

      // temporary - simulating refresh button
      if (sensor.state == DeviceState.Refreshing) {
        new Timer(new Duration(seconds: 5), () {
          debugPrint("Print after 5 seconds");
          refresh();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    this.sensor = sensor;
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SensorItem(sensor),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child:
                    sensor.logs.length > 0 && sensor.state == DeviceState.Loaded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Past Logs'),
                              SizedBox(width: 5),
                              SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                            ],
                          )
                        : Text('No Logs'),
              ),
            ),
            LogItems(sensor),
            RefreshButton(refresh),
          ],
        ),
      ),
    );
  }
}
