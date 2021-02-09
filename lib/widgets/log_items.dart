import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../sensor_bloc.dart';
import '../models/sensor.dart';

class LogItems extends StatelessWidget {
  final Sensor sensor;
  const LogItems(this.sensor);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: sensor.logs.map((log) {
          print(
              'LOADED LOGS: ${log.logId} - ${log.icon} - ${log.progress} - ${log.logState}');
          return Container(
            height: 80,
            child: BlocProvider(
              create: (_) => LogCubit(log),
              child: LogItem(log),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final Log log;
  LogItem(this.log);
  Widget _progressBar(BuildContext context, Log log) {
    return log.logState == LogState.Downloading
        ? LinearProgressIndicator(
            minHeight: double.infinity,
            value: log.progress,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Container();
  }

  Text _displayText(String text, Color color) {
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
    void download(String id, Log log) {
      final logCubit = context.read<LogCubit>();

      logCubit.download();
      new Timer(new Duration(seconds: 2), () {
        if (logCubit.state.progress == 1.0) {
          logCubit.complete();
        } else {
          download(id, log);
        }
      });
    }

    return BlocBuilder<LogCubit, Log>(builder: (_, log) {
      print(
          '---- LOG ITEM UPDATE: ${log.logId} - ${log.icon} - ${log.progress} - ${log.logState}');
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        elevation: 5,
        child: Stack(
          children: [
            _progressBar(context, log),
            ListTile(
              leading: Icon(
                Icons.folder,
                color: log.progress > 0
                    ? Colors.white
                    : Theme.of(context).accentColor,
                size: 40,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // text changes color depending on loading progress bar length
                  // [] fix up these texts
                  _displayText(
                    DateFormat.E().format(log.date),
                    log.progress > 0.2
                        ? Colors.white
                        : Color.fromRGBO(36, 136, 104, 1),
                  ),
                  const SizedBox(width: 10),
                  _displayText(
                    DateFormat.yMd().format(log.date),
                    log.progress > 0.4
                        ? Colors.white
                        : Theme.of(context).accentColor,
                  )
                ],
              ),
              trailing: IconButton(
                icon: log.icon,
                onPressed: () => download(log.logId, log),
              ),
            )
          ],
        ),
      );
    });
  }
}
