import 'package:flutter/material.dart';
import 'package:iot_logger/screens/graph_screen.dart';

import './screens/home_screen.dart';
import './screens/logs_screen.dart';
import './screens/readings_screen.dart';

void main() => runApp(IotLoggerApp());

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
        textTheme: ThemeData.light().textTheme.copyWith(
            headline1: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
            headline5: TextStyle(
              color: darkGreen,
              // fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            headline6: TextStyle(fontSize: 23),
            bodyText1: TextStyle(color: darkGreen, fontSize: 18),
            bodyText2: TextStyle(color: darkBlue)),
      ),
      routes: {
        '/': (ctx) => HomeScreen(),
        '/logs': (ctx) => LogsScreen(),
        '/readings': (ctx) => ReadingsScreen(),
        '/graph-reading': (ctx) => GraphScreen(),
      },
    );
  }
}
