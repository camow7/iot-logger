import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../cubits/sensor_cubit.dart';

import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';
import '../widgets/log_items.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorCubit(),
      child: SensorLogs(),
    );
  }
}

class SensorLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void refresh() {
      context.read<SensorCubit>().reload();
    }

    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    // this.sensor = sensor;
    return Scaffold(
      body: Layout(
        BlocBuilder<SensorCubit, DeviceState>(
          builder: (_, sensorState) {
            sensor.state = sensorState;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SensorItem(sensor),
                Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: sensor.logs.length > 0 &&
                            sensor.state == DeviceState.Loaded
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Past Logs'),
                              SizedBox(width: 5),
                              SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                            ],
                          )
                        : Text('No Logs'),
                  ),
                ),
                LogItems(sensor),
                RefreshButton(refresh),
              ],
            );
          },
        ),
      ),
    );
  }
}