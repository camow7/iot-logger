import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:iot_logger/cubits/log_download/log_download_cubit.dart';
import 'package:iot_logger/cubits/sensor_load/sensor_load_cubit.dart';
import 'package:iot_logger/cubits/sensor_logs/sensor_logs_cubit.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import 'sensor_item.dart';
import 'log_items.dart';

class SensorLogs extends StatelessWidget {
  final Sensor sensor;
  const SensorLogs(this.sensor);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => SensorLoadCubit(),
        child: _SensorLogs(sensor),
      ),
      BlocProvider(
        create: (_) => LogDownloadCubit(),
        child: AllList(sensor),
      )
    ], child: _SensorLogs(sensor));
  }
}

class _SensorLogs extends StatelessWidget {
  final Sensor sensor;
  const _SensorLogs(this.sensor);
  @override
  Widget build(BuildContext context) {
    void _refresh() {
      context.read<SensorLoadCubit>().refresh();
      new Timer(new Duration(seconds: 2), () {
        if (context.read<SensorLoadCubit>().state.progress == 1) {
          context.read<SensorLoadCubit>().complete();
        } else {
          _refresh();
        }
      });
    }

    // final _sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return BlocBuilder<SensorLoadCubit, SensorLoadState>(
      builder: (_, state) {
        // print('-- ${state.deviceState}, ${state.progress}');
        sensor.state = state.deviceState;
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              onPressed: () => context.read<SensorLogsCubit>().hideLogs(),
              child: SensorItem(sensor: sensor, progress: state.progress),
            ),
            // Card(
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //     child: sensor.logs.length > 0 &&
            //             sensor.state == DeviceState.Loaded
            //         ? Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               const Text('Past Logs'),
            //               const SizedBox(width: 5),
            //               SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
            //             ],
            //           )
            //         : const Text('No Logs'),
            //   ),
            // ),
            // LogItems(sensor),
            Container(
              child: AllList(sensor),
            ),
            RefreshButton(_refresh),
          ],
        );
      },
    );
  }
}

Widget miniCard(Sensor sensor, String text) {
  return Card(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 5),
          SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
        ],
      ),
      // child: sensor.logs.length > 0 && sensor.state == DeviceState.Loaded
      //     ? Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Text('Past Logs'),
      //           const SizedBox(width: 5),
      //           SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
      //         ],
      //       )
      //     : const Text('No Logs'),
    ),
  );
}

class AllList extends StatelessWidget {
  final Sensor sensor;
  const AllList(this.sensor);

  void hasClicked() {
    print('clicked');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogDownloadCubit, LogDownloadState>(builder: (_, state) {
      print('${state.status}, ${state.date}');
      return Column(
        children: [
          state.status != LogStatus.Viewing
              ? miniCard(sensor, 'Past Logs')
              : miniCard(sensor, state.date),
          Column(
            children: state.status != LogStatus.Viewing
                ? sensor.logs.map((log) {
                    return FlatButton(
                      onPressed: () => context
                          .read<LogDownloadCubit>()
                          .view(DateFormat.yMd().format(log.date)),
                      child: LogItems(log),
                    );
                  }).toList()
                : [Text('Turb stuff')],
          )
        ],
      );
    });
  }
}
