import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';

class SensorItem extends StatelessWidget {
  final Sensor sensor;

  SensorItem(this.sensor);

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

  @override
  Widget build(BuildContext context) {
    String path = ModalRoute.of(context).settings.name; // current screen path
    SvgPicture svgImage = SvgPicture.asset(
      'assets/svgs/${sensor.iconPath}.svg',
      color: Theme.of(context).accentColor,
    );
    return Container(
      width: double.infinity,
      height: 140,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        elevation: 5,
        child: InkWell(
          onTap: () =>
              path == '/logs' ? returnHome(context) : viewLogs(context),
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Container(
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 20,
                  color: color,
                ),
                title: Text(
                  sensor.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 30,
                  ),
                ),
                trailing: svgImage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
