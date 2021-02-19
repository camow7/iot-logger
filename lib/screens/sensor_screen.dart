import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sensor.dart';
import '../shared/layout.dart';
import '../shared/main_card.dart';

class SensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensor = ModalRoute.of(context).settings.arguments as Sensor;
    return Layout(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BackButton(),
          Text(
            sensor.name,
            style: Theme.of(context).textTheme.headline1,
          ),
          Container(
            height: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MainCard(
                  content: InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/logs', arguments: sensor),
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.folder,
                          color: Theme.of(context).accentColor,
                          size: 50,
                        ),
                        title: cardText(context, 'Download Logs'),
                      ),
                    ),
                  ),
                ),
                MainCard(
                  content: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/readings',
                      arguments: {
                        'sensor': sensor,
                        'readings': sensor.readings,
                      },
                    ),
                    child: Center(
                      child: ListTile(
                        leading: SvgPicture.asset('assets/svgs/real-time.svg'),
                        title: cardText(context, 'Real-time data'),
                      ),
                    ),
                  ),
                ),
                MainCard(
                  content: InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/settings', arguments: sensor),
                    child: Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: Theme.of(context).accentColor,
                          size: 50,
                        ),
                        title: cardText(context, 'Settings'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text cardText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 30),
    );
  }
}
