import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:iot_logger/models/sensor.dart';
import 'package:iot_logger/shared/rive_animation.dart';

class LogCard extends StatelessWidget {
  final Sensor sensor;
  final double progressPercent;
  final Function downloadHandler;
  final DateTime logDate;

  LogCard({
    this.sensor,
    this.progressPercent,
    this.downloadHandler,
    this.logDate
  });

  Text displayText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.folder,
        color: progressPercent > 0 ? Colors.white : Theme.of(context).accentColor,
        size: 40,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // [] fix up these texts
          displayText(
            DateFormat.E().format(logDate),
            progressPercent > 0.2 ? Colors.white : Color.fromRGBO(36, 136, 104, 1),
          ),
          SizedBox(width: 10),
          displayText(
            DateFormat.yMd().format(logDate),
            progressPercent > 0.4 ? Colors.white : Theme.of(context).accentColor,
          )
        ],
      ),
      trailing: IconButton(
          icon: sensor.state != DeviceState.Downloading
              ? SvgPicture.asset(
                  'assets/svgs/download.svg',
                  color: Theme.of(context).accentColor,
                )
              : progressPercent > 0.8
                  ? Container()
                  : RiveAnimation(),
          onPressed: downloadHandler),
    );
  }
}