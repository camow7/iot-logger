import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import '../shared/main_card.dart';

class SensorItem extends StatelessWidget {
  const SensorItem();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SensorCubit, SensorState>(
      listener: (context, state) {
        if (state is Disconnected && !state.networkFound) {
          print("Showing interfaces");
          showDialog(
            context: context,
            builder: (_) => showInterfaces(context, state.networks),
            barrierDismissible: true,
          );
        }
      },
      builder: (context, state) {
        if (state is Connected) {
          return MainCard(
            content: InkWell(
              splashColor: ModalRoute.of(context).settings.name == "/"
                  ? Colors.grey
                  : Colors.white,
              onTap: () => {
                if (ModalRoute.of(context).settings.name == "/")
                  {
                    Navigator.of(context).pushNamed('/sensor'),
                  }
              },
              borderRadius: BorderRadius.circular(4),
              child: sensorContent(
                  context, getStatusImage(context, true), true, state.sensorID),
            ),
          );
        } else {
          return MainCard(
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: sensorContent(context, getStatusImage(context, false),
                  false, state.sensorID),
            ),
          );
        }
      },
    );
  }

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

  Widget sensorContent(BuildContext context, SvgPicture svgImage,
      bool isConnected, String sensorID) {
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
        title: Text(
          "$sensorID",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3.copyWith(
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
        ),
        trailing: svgImage,
      ),
    );
  }

  showInterfaces(BuildContext context, List<NetworkInterface> networks) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width * 0.50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                "Please select your Wi-Fi interface below:",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ListView(
                shrinkWrap: true,
                children: networks
                    .map((network) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context)
                                    .primaryColor), // background color
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                                // fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<SensorCubit>()
                                .connectUsingInterface(network);
                            Navigator.pop(context);
                          },
                          child: Text(
                              "${network.name} - ${network.addresses[0].address}"),
                        )))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
