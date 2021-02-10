import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../cubits/sensor/sensor_cubit.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';
import '../widgets/log_items.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorCubit(),
      child: _SensorLogs(),
    );
  }
}

class _SensorLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _refresh() {
      context.read<SensorCubit>().refresh();
      new Timer(new Duration(seconds: 2), () {
        if (context.read<SensorCubit>().state.progress == 1) {
          context.read<SensorCubit>().complete();
        } else {
          _refresh();
        }
      });
    }

    final _sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Scaffold(
      body: Layout(
        BlocBuilder<SensorCubit, SensorState>(
          builder: (_, state) {
            // print('-- ${state.deviceState}, ${state.progress}');
            _sensor.state = state.deviceState;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SensorItem(sensor: _sensor, progress: state.progress),
                Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: _sensor.logs.length > 0 &&
                            _sensor.state == DeviceState.Loaded
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
                LogItems(_sensor),
                RefreshButton(_refresh),
              ],
            );
          },
        ),
      ),
    );
  }
}
