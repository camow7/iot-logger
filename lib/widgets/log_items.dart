import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubits/log_download/log_download_cubit.dart';
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
          // print(
          //     'LOADED LOGS: ${log.logId} - ${log.progress} - ${log.logState}');
          return Container(
            height: 80,
            child: BlocProvider(
              create: (_) => LogDownloadCubit(),
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
      context.read<LogDownloadCubit>().download();
      new Timer(new Duration(seconds: 2), () {
        if (context.read<LogDownloadCubit>().state.progress == 1.0) {
          context.read<LogDownloadCubit>().complete();
          context.read<LogDownloadCubit>().close();
        } else {
          _download();
        }
      });
    }

    return BlocBuilder<LogDownloadCubit, LogDownloadState>(builder: (_, state) {
      // print('${state.progress}, ${state.status}, ${state.icon}');
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
              leading: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Icon(
                    Icons.folder,
                    color: state.progress > 0
                        ? Colors.white
                        : Theme.of(context).accentColor,
                    size: 40,
                  ),
                  Text(
                    '${(state.progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // text changes color depending on loading progress bar length
                  formatText(
                    DateFormat.E().format(log.date),
                    state.progress > 0.2
                        ? Colors.white
                        : Color.fromRGBO(36, 136, 104, 1),
                  ),
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
