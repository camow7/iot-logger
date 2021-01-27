import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';

class SensorItem extends StatelessWidget {
  final Sensor sensor;

  const SensorItem(this.sensor);

  Color get color {
    switch (sensor.status) {
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
    Navigator.of(context).pushNamed('/logs', arguments: sensor);
  }

  void returnHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget get deviceText {
    return Text(
      sensor.state == DeviceState.Downloading ? '0%' : sensor.name,
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  Widget get deviceCard {
    return Container(
      width: double.infinity,
      height: 140,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        elevation: 5,
        color: Colors.white,
        child: Center(
          child: sensor.state == DeviceState.Downloading
              ? deviceText
              : Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 20,
                      color: color,
                    ),
                    title: deviceText,
                    trailing:
                        SvgPicture.asset('assets/svgs/${sensor.iconPath}.svg'),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String path = ModalRoute.of(context).settings.name; // current screen path
    return sensor.state == DeviceState.Refreshing
        ? Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0.6, child: deviceCard),
              SvgPicture.asset('assets/svgs/loading-arrows.svg')
            ],
          )
        : InkWell(
            onTap: () =>
                path == '/logs' ? returnHome(context) : viewLogs(context),
            splashColor: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: deviceCard,
          );
  }
}
