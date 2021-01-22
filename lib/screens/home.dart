import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../sensor_item.dart';

class Home extends StatelessWidget {
  final List<Sensor> sensors = [
    Sensor(
      id: '1',
      name: 'Water Tank',
      status: Status.Connected,
      iconPath: 'plug',
    ),
    Sensor(
      id: '2',
      name: 'Sewerage',
      status: Status.Idle,
      iconPath: 'plug',
    ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/land.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      child: SvgPicture.asset(
                        'assets/svgs/saphi-logo-white-text.svg',
                        width: 150,
                      ),
                    ),
                  ],
                ),
                Column(
                  children:
                      sensors.map((sensor) => SensorItem(sensor)).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(40),
                  elevation: 3,
                  color: Color.fromRGBO(108, 194, 130, 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
