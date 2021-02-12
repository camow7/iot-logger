import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:iot_logger/cubits/sensor_logs/sensor_logs_cubit.dart';
import 'package:iot_logger/shared/log_list.dart';

import '../cubits/log_download/log_download_cubit.dart';
import '../models/sensor.dart';

class LogItems extends StatelessWidget {
  // final Sensor sensor;
  // const LogItems(this.sensor);

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 300,
  //     child: Column(
  //       children: sensor.logs.map((log) {
  //         // print(
  //         //     'LOADED LOGS: ${log.logId} - ${log.progress} - ${log.logState}');
  //         return Container(
  //           height: 80,
  //           child: MultiBlocProvider(providers: [
  //             BlocProvider(
  //               create: (_) => LogDownloadCubit(),
  //               child: TestWidget(),
  //             ),
  //             BlocProvider(
  //               create: (_) => SensorLogsCubit(),
  //               child: _LogItem(log),
  //             ),
  //           ], child: _LogItem(log)),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  final Log log;
  const LogItems(this.log);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogDownloadCubit(),
      child: _LogItem(log),
    );
  }
}

// class TestWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SensorLogsCubit, SensorLogsState>(builder: (_, state) {
//       print(state);
//       return Text('sora khan');
//     });
//   }
// }

class _LogItem extends StatelessWidget {
  final Log log;
  const _LogItem(this.log);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogDownloadCubit, LogDownloadState>(builder: (_, state) {
      print('${state.date}, ${state.progress}, ${state.status}, ${state.icon}');
      print('${log.progress}, ${log.logState}');
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        child: logTile(context, state),
      );

      //   margin: const EdgeInsets.symmetric(
      //     horizontal: 40,
      //     vertical: 10,
      //   ),
      //   elevation: 5,
      //   child:
      //       // state.status != LogStatus.Downloaded
      //       //     ? logTile(context, state)
      //       //     :
      //       FlatButton(
      //           // user InkWell later
      //           onPressed: () => context.read<LogDownloadCubit>().view(),
      //           child: state.status == LogStatus.Viewing
      //               ? TestWidget()
      //               : logTile(context, state)),
      // );
    });
  }

  showLogData(BuildContext context) {
    print('showing log data');
    context.read<SensorLogsCubit>().showLogs();
    print(context.read<SensorLogsState>().showLogs);
    // print("here: ${context.read<SensorLogsState>().showLogs}");
  }

  Widget logTile(BuildContext context, LogDownloadState state) {
    return Stack(
      children: [
        LinearProgressIndicator(
          minHeight: 60,
          value: state.progress,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        ListTile(
          leading: folderIcon(context, state),
          title: logDate(context, state),
          trailing: IconButton(
            icon: state.icon,
            onPressed: () => _download(context),
          ),
        )
      ],
    );
  }

  void _download(BuildContext context) {
    context.read<LogDownloadCubit>().download();
    new Timer(new Duration(seconds: 2), () {
      if (context.read<LogDownloadCubit>().state.progress == 1.0) {
        context.read<LogDownloadCubit>().complete();
        context.read<LogDownloadCubit>().close();
      } else {
        _download(context);
      }
    });
  }

  Widget folderIcon(BuildContext context, LogDownloadState state) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Icon(
          Icons.folder,
          color:
              state.progress > 0 ? Colors.white : Theme.of(context).accentColor,
          size: 40,
        ),
        Text(
          '${(state.progress * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 10,
          ),
        )
      ],
    );
  }

  Widget logDate(BuildContext context, LogDownloadState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // text changes color depending on loading progress bar length
        formatText(
          DateFormat.E().format(log.date),
          state.progress > 0.2 ? Colors.white : Color.fromRGBO(36, 136, 104, 1),
        ),
        formatText(
          DateFormat.yMd().format(log.date),
          state.progress > 0.4 ? Colors.white : Theme.of(context).accentColor,
        )
      ],
    );
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
