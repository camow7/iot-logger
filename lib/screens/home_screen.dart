import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/sensor_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SensorItem(),
            RefreshButton(),
          ],
        ),
      ),
    );
  }

  void checkPermissions() async {
    if (!Platform.isWindows) {
      await Permission.locationWhenInUse.request();
      await Permission.storage.request();
    }
  }
}
