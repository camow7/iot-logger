import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_load/sensor_load_cubit.dart';

import '../models/sensor.dart';
import '../shared/refresh_button.dart';
import 'sensor_item.dart';
import 'log_items.dart';

class SensorLogs extends StatelessWidget {
  final Sensor sensor;
  const SensorLogs(this.sensor);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorLoadCubit(),
      child: _SensorLogs(sensor),
    );
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
                SensorItem(sensor: sensor, progress: state.progress),
                Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: sensor.logs.length > 0 &&
                            sensor.state == DeviceState.Loaded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Past Logs'),
                              const SizedBox(width: 5),
                              SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                            ],
                          )
                        : const Text('No Logs'),
                  ),
                ),
                LogItems(sensor),
                RefreshButton(_refresh),
              ],
            );
          },
        );
  }
}
