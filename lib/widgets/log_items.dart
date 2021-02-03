import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../models/sensor.dart';

class LogItems extends StatelessWidget {
  final Sensor sensor;

  const LogItems(this.sensor);

  TextStyle dateStyle(BuildContext context, bool isDay) {
    return TextStyle(
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: isDay
            ? Color.fromRGBO(36, 136, 104, 1)
            : Theme.of(context).accentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          color: Theme.of(context).accentColor,
                          size: 40,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // [] fix up these texts
                            Text(
                              DateFormat.E().format(log),
                              style: dateStyle(context, true),
                            ),
                            SizedBox(width: 10),
                            Text(DateFormat.yMd().format(log),
                                style: dateStyle(context, false))
                          ],
                        ),
                        trailing: SvgPicture.asset(
                          'assets/svgs/download.svg',
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          : Container(),
    );
  }
}
