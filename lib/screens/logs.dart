import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/sensor.dart';

import '../widgets/layout.dart';
import '../widgets/refresh_button.dart';
import '../widgets/sensor_item.dart';

class Logs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SensorItem(sensor),
            Container(
              height: 300,
              child: Column(
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
                            Text( // fix up these texts
                              DateFormat.E().format(log),
                              style: TextStyle(
                                  fontSize: 22, fontStyle: FontStyle.italic, color: Color.fromRGBO(36, 136, 104, 1)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateFormat.yMd().format(log),
                              style: TextStyle(
                                  fontSize: 22, fontStyle: FontStyle.italic),
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            RefreshButton(),
          ],
        ),
      ),
    );
  }
}
