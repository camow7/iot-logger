import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import 'package:iot_logger/cubits/sensor_reading_cubit/sensor_reading_cubit.dart';

import '../shared/layout.dart';
import '../shared/main_card.dart';

class SensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.height * 0.1;

    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // Screen Title: Turbidity
          children: [
            BlocBuilder<SensorCubit, SensorState>(
              builder: (_, state) {
                return Text(
                  "${state.sensorID}",
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
            Container(
              // color: Colors.blue[50],
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: MainCard(
                      content: InkWell(
                        onTap: () => {
                          Navigator.of(context).pushNamed('/logs'),
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.folder,
                                color: Theme.of(context).accentColor,
                                size: iconSize,
                              ),
                              Container(
                                child: cardText(context, 'Download Logs'),
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: MainCard(
                      content: InkWell(
                        onTap: () => {
                          context
                              .read<SensorReadingCubit>()
                              .getCurrentMeasurements(),
                          Navigator.of(context).pushNamed('/readings'),
                        },
                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: iconSize,
                                  width: iconSize,
                                  child: SvgPicture.asset(
                                      'assets/svgs/real-time.svg'),
                                ),
                                Container(
                                  child: cardText(context, 'Real-time data'),
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: MainCard(
                      content: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/settings'),
                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: Theme.of(context).accentColor,
                                  size: iconSize,
                                ),
                                Container(
                                  child: cardText(context, 'Settings'),
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
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
          .copyWith(fontSize: (MediaQuery.of(context).size.width * 0.05)),
    );
  }
}
