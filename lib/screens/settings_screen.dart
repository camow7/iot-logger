import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/shared/layout.dart';
import 'package:iot_logger/shared/setting_card.dart';
import 'package:iot_logger/shared/styling.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      content: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headline1,
          ),
          SettingCard(
            icon: setIcon(Icons.watch_later_outlined),
            text: 'Sensor Time',
          ),
          SettingCard(
            icon: setSvgImage('assets/svgs/wifi.svg'),
            text: 'Wi-Fi',
          ),
          SettingCard(
            icon: setIcon(Icons.folder),
            text: 'Logging',
          ),
        ],
      ),
    );
  }
}
