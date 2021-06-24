import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import 'package:iot_logger/cubits/sensor_reading_cubit/sensor_reading_cubit.dart';
import 'package:flutter/services.dart';
import '../shared/layout.dart';
import '../shared/main_card.dart';
import 'dart:io';

class SensorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PortraitLock(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double cardWidth =
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * (isLandscape ? 0.6 : 0.5);
    double cardHeight =
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
            ? MediaQuery.of(context).size.height * 0.2
            : MediaQuery.of(context).size.height * (isLandscape ? 0.23 : 0.2);
    double iconSize =
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
            ? MediaQuery.of(context).size.height * 0.1
            : MediaQuery.of(context).size.height * (isLandscape ? 0.185 : 0.1);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Layout(
        content: Column(
          mainAxisAlignment:
              (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
          // Screen Title (i.e Turbidity)
          children: <Widget>[
            //sus
            BlocBuilder<SensorCubit, SensorState>(
              builder: (_, state) {
                return Text(
                  "${state.sensorID}",
                  style: Theme.of(context).textTheme.headline1,
                );
              },
            ),
            // Menu
            Container(
              // color: Colors.blue[50],
              height:
                  (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                      ? MediaQuery.of(context).size.height * 0.7
                      : null,
              child: Column(
                mainAxisAlignment:
                    (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.start,
                crossAxisAlignment:
                    (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.stretch,
                children: <Widget>[
                  //sus
                  // Download Log Button
                  Container(
                    height: cardHeight,
                    width: cardWidth,
                    child: MainCard(
                      content: InkWell(
                        onTap: () => {
                          Navigator.of(context).pushNamed('/logs'),
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: (Platform.isWindows ||
                                    Platform.isMacOS ||
                                    Platform.isLinux)
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            children: <Widget>[
                              //sus
                              Icon(
                                Icons.folder,
                                color: Theme.of(context).accentColor,
                                size: iconSize,
                              ),
                              Container(
                                child: cardText(context, 'Download Logs',
                                    isLandscape), //sus
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: cardHeight,
                    width: cardWidth,
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
                              mainAxisAlignment: (Platform.isWindows ||
                                      Platform.isMacOS ||
                                      Platform.isLinux)
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.center,
                              children: <Widget>[
                                //sus
                                Container(
                                  height: iconSize,
                                  width: iconSize,
                                  child: SvgPicture.asset(
                                      'assets/svgs/real-time.svg'),
                                ),
                                Container(
                                  child: cardText(
                                      context, 'Real-time data', isLandscape),
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
                    height: cardHeight,
                    width: cardWidth,
                    child: MainCard(
                      content: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/settings'),
                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: (Platform.isWindows ||
                                      Platform.isMacOS ||
                                      Platform.isLinux)
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.center,
                              children: <Widget>[
                                //sus
                                Icon(
                                  Icons.settings,
                                  color: Theme.of(context).accentColor,
                                  size: iconSize,
                                ),
                                Container(
                                  child: cardText(
                                      context, 'Settings', isLandscape),
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

  Text cardText(BuildContext context, String text, isLandscape) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline3.copyWith(
          fontSize: ((Platform.isWindows)
              ? MediaQuery.of(context).size.width * 0.03
              : (isLandscape ? 0.02 : 0.055))),
    );
  }
}

void PortraitLock(BuildContext context) {
  if ((MediaQuery.of(context).size.height < 600) ||
      (MediaQuery.of(context).size.width < 600)) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
