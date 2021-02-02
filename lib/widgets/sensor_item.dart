import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/widgets/rive_animation.dart';

import '../models/sensor.dart';

class SensorItem extends StatefulWidget {
  final Sensor sensor;

  const SensorItem(this.sensor);

  @override
  _SensorItemState createState() => _SensorItemState();
}

class _SensorItemState extends State<SensorItem> {
  Color get color {
    switch (widget.sensor.status) {
      case Status.Connected:
        return Colors.green;
        break;
      case Status.Idle:
        return Colors.amber;
        break;
      case Status.Disconnected:
        return Colors.red;
        break;
      default:
        return Colors.grey;
    }
  }

  void viewLogs(BuildContext context) {
    Navigator.of(context).pushNamed('/logs', arguments: widget.sensor);
  }

  void returnHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget get deviceText {
    return Text(
      widget.sensor.state == DeviceState.Downloading
          ? '0%'
          : widget.sensor.name,
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  var progress = 0.0;

  download() {
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
  move() {
    new Timer(new Duration(seconds: 2), () {
      setState(() {
        progress += 0.2;
        progress > 1 ? download() : move();
      });
    });
  }

  Widget get deviceCard {
    String path = ModalRoute.of(context).settings.name; // current screen path
    SvgPicture svgImage =
        SvgPicture.asset('assets/svgs/${widget.sensor.iconPath}.svg');
    return Container(
      width: double.infinity,
      height: 140,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        elevation: 5,
        color: Colors.white,
        child: InkWell(
          onTap: () =>
              path == '/logs' ? returnHome(context) : viewLogs(context),
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: widget.sensor.state == DeviceState.Downloading
                ? LinearProgressIndicator(
                    minHeight: 140,
                    value: progress,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ) // deviceText
                : Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.circle,
                        size: 20,
                        color: color,
                      ),
                      title: deviceText,
                      trailing: widget.sensor.iconPath == 'download-light'
                          ? IconButton(icon: svgImage, onPressed: download)
                          : svgImage,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // current screen path
    return widget.sensor.state == DeviceState.Connecting
        ? Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0.6, child: deviceCard),
              // SvgPicture.asset('assets/svgs/loading-arrows.svg')
              Container(
                width: 100,
                height: 100,
                child: RiveAnimation(),
              )
            ],
          )
        : deviceCard;
  }
}
