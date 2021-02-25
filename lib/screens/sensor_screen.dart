import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_reading_cubit/sensor_reading_cubit.dart';

import '../shared/layout.dart';
import '../shared/main_card.dart';

class SensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Sensor 1",
              style: Theme.of(context).textTheme.headline1,
            ),
            Container(
              // color: Colors.blue[50],
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainCard(
                    content: InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/logs'),
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
                      onTap: () => {
                        context
                            .read<SensorReadingCubit>()
                            .getCurrentMeasurements(),
                        Navigator.of(context).pushNamed('/readings'),
                      },
                      child: Center(
                        child: ListTile(
                          leading:
                              SvgPicture.asset('assets/svgs/real-time.svg'),
                          title: cardText(context, 'Real-time data'),
                        ),
                      ),
                    ),
                  ),
                  MainCard(
                    content: InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/settings'),
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
      ),
    );
  }

  Text cardText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headline3
          .copyWith(fontSize: (MediaQuery.of(context).size.width * 0.07)),
    );
  }
}
