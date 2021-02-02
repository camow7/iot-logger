import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/logs.dart';

void main() => runApp(IotLoggerApp());

class IotLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IoT Logger',
        theme: ThemeData(
          accentColor: const Color.fromRGBO(108, 194, 130, 1),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                headline6: const TextStyle(
                  // color: Color.fromRGBO(36, 136, 104, 1),
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400
                ),
                button: const TextStyle(
                  color: Colors.white,
                ),
              ),
        ),
        routes: {
          '/': (ctx) => Home(),
          '/logs': (ctx) => Logs(),
        });
  }
}
