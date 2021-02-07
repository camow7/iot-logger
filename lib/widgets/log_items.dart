import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../sensor_bloc.dart';
import '../shared/rive_animation.dart';
import '../models/sensor.dart';

class LogItems extends StatelessWidget {
  final Sensor sensor;
  const LogItems(this.sensor);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogBloc(),
      child: Logs(sensor),
    );
  }
}

class Logs extends StatelessWidget {
  final Sensor sensor;
  const Logs(this.sensor);

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

  Widget logStateIcon(BuildContext context, LogDownloadState device) {
    switch (device.logState) {
      case LogState.Loaded:
        return SvgPicture.asset(
          'assets/svgs/download.svg',
          color: Theme.of(context).accentColor,
        );
        break;
      case LogState.Downloading:
        if (device.progress == 1) {
          context.read<LogBloc>().add(LogEvent.completeDownload);
        }
        return RiveAnimation();
        break;
      case LogState.Downloaded:
        return Container();
        break;
      default:
        return Container();
        break;
    }
  }

  Widget progressBar(BuildContext context, LogDownloadState logData) {
    return logData.logState == LogState.Downloading
        ? LinearProgressIndicator(
            minHeight: double.infinity,
            value: logData.progress,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: sensor.logs.map(
          (log) {
            return Container(
              height: 80,
              child: Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                elevation: 5,
                child: BlocBuilder<LogBloc, LogDownloadState>(
                  builder: (_, logData) {
                    return Stack(
                      children: [
                        progressBar(context, logData),
                        ListTile(
                          leading: Icon(
                            Icons.folder,
                            color: logData.progress > 0
                                ? Colors.white
                                : Theme.of(context).accentColor,
                            size: 40,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // text changes color depending on loading progress bar length
                              // [] fix up these texts
                              displayText(
                                DateFormat.E().format(log),
                                logData.progress > 0.2
                                    ? Colors.white
                                    : Color.fromRGBO(36, 136, 104, 1),
                              ),
                              SizedBox(width: 10),
                              displayText(
                                DateFormat.yMd().format(log),
                                logData.progress > 0.4
                                    ? Colors.white
                                    : Theme.of(context).accentColor,
                              )
                            ],
                          ),
                          trailing: IconButton(
                              icon: logStateIcon(context, logData),
                              onPressed: logData.logState == LogState.Loaded
                                  ? () => context
                                      .read<LogBloc>()
                                      .add(LogEvent.downloading)
                                  : null),
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
