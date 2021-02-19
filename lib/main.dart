import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import 'package:iot_logger/screens/sensor_screen.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/logs_screen.dart';
import './screens/readings_screen.dart';
import './screens/graph_screen.dart';
import 'services/arduino_repository.dart';

ArduinoRepository arduinoRepo = ArduinoRepository();

void main() => runApp(
      MultiProvider(
        providers: [
          //Create
          BlocProvider(
              create: (context) => SensorCubit(arduinoRepo)..connect()),
        ],
        child: IotLoggerApp(),
      ),
    );

class IotLoggerApp extends StatelessWidget {
  final green = const Color.fromRGBO(108, 194, 130, 1);
  final darkGreen = const Color.fromRGBO(36, 136, 104, 1);
  final darkBlue = const Color.fromRGBO(57, 68, 76, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Logger',
      theme: ThemeData(
        primaryColor: green,
        focusColor: darkGreen,
        accentColor: darkBlue,
        backgroundColor: Colors.white,
        buttonColor: green,
        fontFamily: 'Montserrat',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
              // headline2: TextStyle(
              //     fontWeight: FontWeight.w600, fontSize: 25, color: darkBlue),
              headline3: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: darkBlue,
              ),
              headline4: TextStyle(
                fontWeight: FontWeight.w600,
                color: darkBlue,
              ),
              headline5: TextStyle(
                color: darkBlue,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              headline6: TextStyle(
                color: darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              bodyText1: TextStyle(
                color: darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              bodyText2: TextStyle(
                color: darkBlue,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              // texts within icons
              subtitle1: TextStyle(
                color: darkBlue,
                fontSize: 10,
              ),
              subtitle2: TextStyle(
                color: darkBlue,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
      ),
      routes: {
        '/': (ctx) => HomeScreen(),
        '/sensor': (ctx) => SensorScreen(),
        '/logs': (ctx) => LogsScreen(),
        '/readings': (ctx) => ReadingsScreen(),
        '/graph-reading': (ctx) => GraphScreen(),
      },
    );
  }
}
