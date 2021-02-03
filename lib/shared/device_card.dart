import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';

class DeviceCard extends StatelessWidget {
  final String screenPath;
  final Sensor sensor;
  final double progressPercent;
  final Function downloadHandler;

  DeviceCard({
    this.screenPath,
    this.sensor,
    this.progressPercent,
    this.downloadHandler,
  });

  void viewLogs(BuildContext context) {
    Navigator.of(context).pushNamed('/logs', arguments: sensor);
  }

  void returnHome(BuildContext context) {
    Navigator.of(context).pop();
  }

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

  Text displayText(String text, BuildContext context) {
    return Text(
      text,
      style: sensor.state == DeviceState.Downloading && progressPercent > 0.5
          ? TextStyle(color: Colors.white, fontSize: 30)
          : TextStyle(color: Theme.of(context).accentColor, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    SvgPicture svgImage = SvgPicture.asset(
      'assets/svgs/${sensor.iconPath}.svg',
      color: Theme.of(context).accentColor,
    );
    const double cardHeight = 140;

    return Container(
      width: double.infinity,
      height: cardHeight,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        elevation: 5,
        child: InkWell(
          onTap: () =>
              screenPath == '/logs' ? returnHome(context) : viewLogs(context),
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: sensor.state == DeviceState.Downloading
                ? Stack(
                    children: [
                      LinearProgressIndicator(
                        minHeight: cardHeight,
                        value: progressPercent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      Center(
                        child: displayText(
                            '${(progressPercent * 100).toStringAsFixed(0)}%',
                            context),
                      )
                    ],
                  )
                : Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.circle,
                        size: 20,
                        color: color,
                      ),
                      title: displayText(sensor.name, context),
                      trailing: sensor.iconPath == 'download-light'
                          ? IconButton(
                              icon: svgImage, onPressed: downloadHandler)
                          : svgImage,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
