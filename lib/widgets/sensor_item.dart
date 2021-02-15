import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/main_card.dart';

class SensorItem extends StatelessWidget {
  final Sensor sensor;
  final double progress;

  SensorItem({this.sensor, this.progress});

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
      child: MainCard(
        path == '/'
            ? InkWell(
                onTap: () => viewLogs(context),
                borderRadius: BorderRadius.circular(4),
                child: sensorContent(context, svgImage),
              )
            : sensorContent(context, svgImage),
      ),
    );
  }

  Widget sensorContent(BuildContext context, SvgPicture svgImage) {
    return Center(
      child: ListTile(
        leading: sensor.state == DeviceState.Loaded
            ? Icon(
                Icons.circle,
                size: 20,
                color: color,
              )
            : Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 10),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).accentColor,
                    value: progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  )
                ],
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
    );
  }
}
