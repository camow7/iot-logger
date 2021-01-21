import 'package:flutter/material.dart';

import './home_screen.dart';

void main() => runApp(IotLoggerApp());

class IotLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Logger',
      home: HomeScreen(),
    );
  }
}