import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iot_logger/shared/log_card.dart';

import '../models/sensor.dart';

class LogItems extends StatefulWidget {
  final Sensor sensor;

  const LogItems(this.sensor);

  @override
  _LogItemsState createState() => _LogItemsState();
}

class _LogItemsState extends State<LogItems> {
  var progress = 0.0;

  void download() {
    setState(() {
      widget.sensor.state =
          widget.sensor.state == DeviceState.Loaded && progress <= 1
              ? DeviceState.Downloading
              : DeviceState.Loaded;
    });

    if (widget.sensor.state == DeviceState.Downloading) {
      move();
    }
  }

  void move() {
    new Timer(new Duration(seconds: 2), () {
      setState(() {
        progress += 0.2;

        if (progress > 1) {
          progress = 0;
          download();
        } else {
          move();
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: widget.sensor.logs.map(
          (log) {
            return Container(
              height: 80,
              child: Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                elevation: 5,
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      minHeight: double.infinity,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    LogCard(
                      sensor: widget.sensor,
                      progressPercent: progress,
                      logDate: log,
                      downloadHandler: download,
                    )
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
