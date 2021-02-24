import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/settings_cubit/settings_cubit.dart';
import '../shared/layout.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Layout(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (_, state) {
                if (state is Loaded) {
                  return Container(
                    // color: Colors.blue[50],
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      children: [
                        //Sensor Time
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  accentColor: Colors.green,
                                  unselectedWidgetColor: Colors.green,
                                  iconTheme: IconThemeData(
                                    size: 35,
                                    color: Colors.green,
                                  ),
                                ),
                                child: ExpansionTile(
                                  maintainState: true,
                                  onExpansionChanged: (value) {},
                                  // initiallyExpanded: true,
                                  backgroundColor: Colors.white,
                                  leading: Icon(
                                    Icons.query_builder,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  title: Text(
                                    "Sensor Time",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        "Sensor's Time: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.time}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: RaisedButton(
                                        onPressed: () => {
                                          context
                                              .read<SettingsCubit>()
                                              .setArduinoTime(),
                                        },
                                        child: Text(
                                          'Set Time',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        // shape: isLandscape
                                        //     ? Border()
                                        //     : CircleBorder(),

                                        elevation: 3,
                                        textColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //Wifi Details
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  accentColor: Colors.green,
                                  unselectedWidgetColor: Colors.green,
                                  iconTheme: IconThemeData(
                                    size: 35,
                                    color: Colors.green,
                                  ),
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  leading: Icon(
                                    Icons.wifi,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  title: Text(
                                    "Wifi Details",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        "Wifi SSID: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.ssid}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Wifi Password: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.password}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: RaisedButton(
                                          onPressed: () => {
                                            // setLoggingPeriod(context),
                                          },
                                          child: Text(
                                            'Set SSID',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Montserrat'),
                                          ),
                                          elevation: 3,
                                          textColor:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      ),
                                      trailing: RaisedButton(
                                        onPressed: () => {
                                          // setLoggingPeriod(context),
                                        },
                                        child: Text(
                                          'Set Password',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        // shape: isLandscape
                                        //     ? Border()
                                        //     : CircleBorder(),

                                        elevation: 3,
                                        textColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //File Logging Period
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  accentColor: Colors.green,
                                  unselectedWidgetColor: Colors.green,
                                  iconTheme: IconThemeData(
                                    size: 35,
                                    color: Colors.green,
                                  ),
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  leading: Icon(
                                    Icons.folder,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  title: Text(
                                    "File Logging Period",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        "Logging Period: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.loggingPeriod}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: RaisedButton(
                                        onPressed: () => {
                                          // setLoggingPeriod(context),
                                        },
                                        child: Text(
                                          'Set Logging Period',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        elevation: 3,
                                        textColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  accentColor: Colors.green,
                                  unselectedWidgetColor: Colors.green,
                                  iconTheme: IconThemeData(
                                    size: 35,
                                    color: Colors.green,
                                  ),
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Colors.white,
                                  leading: Icon(
                                    Icons.settings,
                                    color: Theme.of(context).accentColor,
                                    size: 30,
                                  ),
                                  title: Text(
                                    "Other",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        "Battery Voltage: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.batteryVoltage}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Battery ADC Reading: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.batteryADC}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Used Storage: ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.usedSpace} B",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Remaining Storage:",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.remainingSpace} B",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: RaisedButton(
                                        onPressed: () => {
                                          refreshOtherSetting(context),
                                        },
                                        child: Text(
                                          'Refresh',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        // shape: isLandscape
                                        //     ? Border()
                                        //     : CircleBorder(),

                                        elevation: 3,
                                        textColor:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text("Loading");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

refreshOtherSetting(BuildContext context) async {
  await context.read<SettingsCubit>().getSDCardInfo();
  await context.read<SettingsCubit>().getBatteryInfo();
}
