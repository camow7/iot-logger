import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/sensor_logs/sensor_logs_cubit.dart';
import 'package:iot_logger/widgets/sensor_logs.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorLogsCubit(),
      child: _Sensors(),
    );
  }
}

class _Sensors extends StatelessWidget {
  final List<Sensor> sensors = [
    Sensor(
        id: '1',
        name: 'Water Tank',
        status: Status.Connected,
        iconPath: 'plug',
        logs: [
          Log(
            date: DateTime.now(),
            logId: '1',
            progress: 0.0,
            logState: LogStatus.Loaded,
          ),
          Log(
            date: DateTime.now(),
            logId: '2',
            progress: 0.0,
            logState: LogStatus.Loaded,
          ),
        ]),
    // Sensor(
    //   id: '2',
    //   name: 'Sewerage',
    //   status: Status.Idle,
    //   iconPath: 'plug',
    // ),
    Sensor(
      id: '3',
      name: 'Pump',
      status: Status.Disconnected,
      iconPath: 'plug',
    ),
    Sensor(
      id: '4',
      name: 'Air Con',
      status: Status.Connected,
      iconPath: 'download-light',
    ),
  ];

  void refreshPage() {
    print('homepage refresh');
  }

  @override
  Widget build(BuildContext context) {
    Sensor _selectedSensor;
    return Scaffold(
      body: Layout(
        BlocBuilder<SensorLogsCubit, SensorLogsState>(
          builder: (_, state) {
            return state.showLogs
                ? FlatButton(
                    onPressed: () => context.read<SensorLogsCubit>().hideLogs(),
                    child: SensorLogs(_selectedSensor),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Your Sensor',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Column(
                        children: sensors
                            .map(
                              (sensor) => FlatButton(
                                onPressed: () => {
                                  context.read<SensorLogsCubit>().showLogs(),
                                  _selectedSensor = sensor
                                },
                                child: SensorItem(sensor: sensor, progress: 0),
                              ),
                            )
                            .toList(),
                      ),
                      RefreshButton(refreshPage),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
