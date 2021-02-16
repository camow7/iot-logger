import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/main_card.dart';

class SensorItem extends StatelessWidget {
  final Sensor sensor;
  const SensorItem(this.sensor);

  SvgPicture getStatusImage(BuildContext context) {
    switch (sensor.status) {
      case DeviceStatus.Connected:
        return SvgPicture.asset('assets/svgs/connected-plug.svg',
            color: Theme.of(context).accentColor);
        break;
      default:
        return SvgPicture.asset('assets/svgs/plug.svg',
            color: Theme.of(context).accentColor);
        break;
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
    return Container(
      width: double.infinity,
      height: 140,
      child: MainCard(
        content: path == '/'
            ? InkWell(
                onTap: () => viewLogs(context),
                borderRadius: BorderRadius.circular(4),
                child: sensorContent(context, getStatusImage(context)),
              )
            : sensorContent(context, getStatusImage(context), path),
      ),
    );
  }

  Widget sensorContent(BuildContext context, SvgPicture svgImage,
      [String path]) {
    return Center(
      child: ListTile(
        leading: path != null && path != '/'
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    '${(sensor.usedSpace * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 10),
                  ),
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    value: sensor.usedSpace,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor,
                    ),
                  )
                ],
              )
            : Icon(
                Icons.circle,
                size: 20,
                color: Colors.green,
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
