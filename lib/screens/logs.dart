import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../models/sensor.dart';

import '../widgets/layout.dart';
import '../widgets/sensor_item.dart';

class Logs extends StatefulWidget {
  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  Sensor sensor;

  // refresh to obtain logs
  void refresh() {
    setState(() {
      sensor.state = sensor.state == DeviceState.Loaded
          ? DeviceState.Connecting
          : DeviceState.Loaded;

      // temporary - simulating refresh button
      if (sensor.state == DeviceState.Connecting) {
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
                child: sensor.logs.length > 0 && sensor.state == DeviceState.Loaded
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

            Container(
              height: 300,
              child: sensor.state == DeviceState.Loaded
                  ? Column(
                      children: sensor.logs.map(
                        (log) {
                          return Container(
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              elevation: 5,
                              child: ListTile(
                                leading: Icon(
                                  Icons.folder,
                                  color: Color.fromRGBO(57, 68, 76, 1),
                                  size: 40,
                                ),
                                title: Row(children: [
                                  Text(
                                    // fix up these texts
                                    DateFormat.E().format(log),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontStyle: FontStyle.italic,
                                        color: Color.fromRGBO(36, 136, 104, 1)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    DateFormat.yMd().format(log),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontStyle: FontStyle.italic),
                                  )
                                ]),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )
                  : Container(),
            ),
            // RefreshButton(),
            RaisedButton(
              onPressed: refresh,
              child: Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(40),
              elevation: 3,
              color: const Color.fromRGBO(108, 194, 130, 1),
            )
          ],
        ),
      ),
    );
  }
}
