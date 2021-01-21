import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import './models/sensor.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListTile(
          leading: Icon(
            Icons.circle,
            size: 20,
            color: color,
          ),
          title: Text(
            sensor.name,
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          trailing: SvgPicture.asset('assets/svgs/${sensor.iconPath}.svg'),
        ),
      ),
    );
  }
}
