import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';

import '../models/sensor.dart';
import '../shared/main_card.dart';

class SensorItem extends StatelessWidget {
  final Sensor sensor;
  const SensorItem(this.sensor);

  SvgPicture getStatusImage(BuildContext context, bool connectionStatus) {
    switch (connectionStatus) {
      case true:
        return SvgPicture.asset('assets/svgs/connected-plug.svg',
            color: Theme.of(context).accentColor);
        break;
      case false:
        return SvgPicture.asset('assets/svgs/plug.svg',
            color: Theme.of(context).accentColor);
        break;
      default:
        return SvgPicture.asset('assets/svgs/plug.svg',
            color: Theme.of(context).accentColor);
        break;
    }
  }

  void viewLogs(BuildContext context) {
    Navigator.of(context).pushNamed('/sensor', arguments: sensor);
  }

  void returnHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final String path =
        ModalRoute.of(context).settings.name; // current screen path
    return BlocBuilder<SensorCubit, SensorState>(builder: (_, state) {
      if (state is Connected) {
        return MainCard(
            content: InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed('/sensor', arguments: sensor),
          borderRadius: BorderRadius.circular(4),
          child: sensorContent(context, getStatusImage(context, true), true),
        ));
      } else {
        return MainCard(
            content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: sensorContent(context, getStatusImage(context, false), false),
        ));
      }
    });
  }

  Widget sensorContent(
      BuildContext context, SvgPicture svgImage, bool isConnected) {
    return Center(
      child: ListTile(
        leading: isConnected
            ? Icon(
                Icons.circle,
                size: 30,
                color: Colors.green,
              )
            : Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  )
                ],
              ),
        title: Text(sensor.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3),
        trailing: svgImage,
      ),
    );
  }
}
