import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';

class HomeScreen extends StatelessWidget {
  final int loggingPeriod = 5000;
  final String logFileName = "DEV-LOG.CSV";
  final List<Sensor> sensors = [
    Sensor(
        id: '1',
        name: 'Water Tank',
        status: Status.Connected,
        iconPath: 'plug',
        logs: [DateTime.now(), DateTime.now()]),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Sensor',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            // Column(
            //   children: sensors.map((sensor) => SensorItem(sensor)).toList(),
            // ),
            // RefreshButton(refresh),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(10.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                context.read<ArduinoBloc>().add(GetLoggingPeriod());
              },
              child: Text(
                "Get Logging Period",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context
                        .read<ArduinoBloc>()
                        .add(SetLoggingPeriod(loggingPeriod));
                  },
                  child: Text(
                    "Set Logging Period",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color.fromRGBO(39, 144, 196, 1),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      //loggingPeriod = int.parse(value);
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(GetBatteryInfo());
                  },
                  child: Text(
                    "Get Battery Info",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  // padding: EdgeInsets.all(10.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(GetSDCardInfo());
                  },
                  child: Text(
                    "Get SD Card Info",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(SetRTCTime());
                  },
                  child: Text(
                    "Set RTC Time",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(GetRTCTime());
                  },
                  child: Text(
                    "Get RTC Time",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(10.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  context.read<ArduinoBloc>().add(GetLogsList());
                },
                child: Text(
                  "Get Logs List",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    context.read<ArduinoBloc>().add(GetLogFile(logFileName));
                  },
                  child: Text(
                    "Get Log File",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color.fromRGBO(39, 144, 196, 1),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      //logFileName = value;
                    },
                  ),
                ),
              ],
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(10.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                context.read<ArduinoBloc>().add(GetCurrentMeasurements(2));
              },
              child: Text(
                "Get Current Measurements",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(10.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                context.read<ArduinoBloc>().add(DeleteLogFile("21-02-08.CSV"));
              },
              child: Text(
                "Delete File",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(10.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                context.read<ArduinoBloc>().add(SetWifiSSID("MATTSArduino"));
              },
              child: Text(
                "Set WIFI SSID",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(10.0),
              splashColor: Colors.blueAccent,
              onPressed: () {
                context.read<ArduinoBloc>().add(SetWifiPassword("password"));
              },
              child: Text(
                "Set Wifi Password",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // To call bloc event (i.e GetFile)
// void submitCityName(BuildContext context, String fileName) {
//   final arduinoBloc = context.bloc<ArduinoBloc>();
//   arduinoBloc.add(GetFile(cityName));
// }
