import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubits/log/log_cubit.dart';
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
              'LOADED LOGS: ${log.logId} - ${log.progress} - ${log.logState}');
          return Container(
            height: 80,
            child: BlocProvider(
              create: (_) => LogCubit(),
              child: _LogItem(log),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final Log log;
  _LogItem(this.log);

  @override
  Widget build(BuildContext context) {
    void _download() {
      context.read<LogCubit>().download();
      new Timer(new Duration(seconds: 2), () {
        if (context.read<LogCubit>().state.progress == 1.0) {
          context.read<LogCubit>().complete();
          context.read<LogCubit>().close();
        } else {
          _download();
        }
      });
    }

    return BlocBuilder<LogCubit, LogState>(builder: (_, state) {
      print('${state.progress}, ${state.status}, ${state.icon}');
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        elevation: 5,
        child: Stack(
          children: [
            LinearProgressIndicator(
              minHeight: double.infinity,
              value: state.progress,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: Icon(
                Icons.folder,
                color: state.progress > 0
                    ? Colors.white
                    : Theme.of(context).accentColor,
                size: 40,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // text changes color depending on loading progress bar length
                  formatText(
                    DateFormat.E().format(log.date),
                    state.progress > 0.2
                        ? Colors.white
                        : Color.fromRGBO(36, 136, 104, 1),
                  ),
                  const SizedBox(width: 10),
                  formatText(
                    DateFormat.yMd().format(log.date),
                    state.progress > 0.4
                        ? Colors.white
                        : Theme.of(context).accentColor,
                  )
                ],
              ),
              trailing: IconButton(
                icon: state.icon,
                onPressed: () => _download(),
              ),
            )
          ],
        ),
      );
    });
  }

  Text formatText(String text, Color color) {
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
}
