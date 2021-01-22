import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/logs.dart';

void main() => runApp(IotLoggerApp());

class IotLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Logger',
      routes: {
        '/': (ctx) => Home(),
        '/logs': (ctx) => Logs(),
      }
    );
  }
}