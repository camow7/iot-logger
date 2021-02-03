import 'dart:async';

import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../shared/rive_animation.dart';
import '../shared/device_card.dart';

class SensorItem extends StatefulWidget {
  final Sensor sensor;

  const SensorItem(this.sensor);

  @override
  _SensorItemState createState() => _SensorItemState();
}

class _SensorItemState extends State<SensorItem> {
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

  // temporary - simulating download button
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

  Stack deviceCardWithAnimation(Widget deviceCard) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.6,
          child: deviceCard,
        ),
        Container(
          width: 100,
          height: 100,
          child: RiveAnimation(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String path = ModalRoute.of(context).settings.name; // current screen path
    Widget deviceCard = DeviceCard(
      screenPath: path,
      downloadHandler: download,
      sensor: widget.sensor,
      progressPercent: progress,
    );
    return widget.sensor.state != DeviceState.Connecting
        ? deviceCard
        : deviceCardWithAnimation(deviceCard);
  }
}
