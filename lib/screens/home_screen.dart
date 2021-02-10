import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../widgets/sensor_item.dart';
import '../shared/refresh_button.dart';

class HomeScreen extends StatelessWidget {
  final List<Sensor> sensors = [
    Sensor(
        id: '1',
        name: 'Water Tank',
        status: Status.Connected,
        iconPath: 'plug',
        logs: [DateTime.now(), DateTime.now()]),
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
      state: DeviceState.Connecting,
    ),
    Sensor(
      id: '4',
      name: 'Air Con',
      status: Status.Connected,
      iconPath: 'download-light',
      // state: DeviceState.Downloading,
    ),
  ];

  void refresh() {
    print('homepage refresh');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Your Sensor',
              style: Theme.of(context).textTheme.headline1,
            ),
            Column(
              children: sensors.map((sensor) => SensorItem(sensor)).toList(),
            ),
            //RefreshButton(refresh),
            BlocBuilder<ArduinoBloc, ArduinoState>(
              builder: (_, state) {
                return FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(GetLoggingPeriod());
                  },
                  child: Text(
                    "Get Logging Period",
                    style: TextStyle(fontSize: 20.0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
