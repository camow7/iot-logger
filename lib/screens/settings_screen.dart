import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/settings_cubit/settings_cubit.dart';
import '../shared/layout.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () => {
                                          context
                                              .read<SettingsCubit>()
                                              .setArduinoTime(),
                                        },
                                        child: Text(
                                          'Set Time',
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
                        //Wifi Details
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () => {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    SetWifiSSID(context, state),
                                                barrierDismissible: true,
                                              ),
                                            },
                                            child: Text(
                                              "Set SSID",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Montserrat'),
                                            ),
                                            elevation: 3,
                                            textColor: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () => {
                                              showDialog(
                                                context: context,
                                                builder: (_) => SetWifiPassword(
                                                    context, state),
                                                barrierDismissible: true,
                                              ),
                                            },
                                            child: Text(
                                              'Set Password',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Montserrat'),
                                            ),
                                            elevation: 3,
                                            textColor: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //File Logging Period
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () => {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  SetLoggingPeriodDialog(
                                                      context, state),
                                              barrierDismissible: true)
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
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                                      title: Text(
                                        "Build Version ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.version}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        "Build Number ",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                        "${state.buildNumber}",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                      title: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () => {
                                          refreshOtherSetting(context),
                                        },
                                        child: Text(
                                          'Refresh',
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
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                    child: Container(
                      // color: Colors.blue[50],
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.width * 0.40,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget SetLoggingPeriodDialog(BuildContext context, state) {
  int loggingPeriod;
  bool loggingPeriodisInt = false;

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "Set Logging Period",
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              style: TextStyle(
                fontSize: 20.0,
                color: loggingPeriodisInt ? Colors.red : Colors.black,
              ),
              maxLines: 1,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '${state.loggingPeriod}',
              ),
              onChanged: (String value) {
                // print("Checking");
                if (int.tryParse(value) != null) {
                  // print("pass");
                  loggingPeriod = int.parse(value);

                  loggingPeriodisInt = true;
                } else {
                  loggingPeriodisInt = false;
                }
              },
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
                VerticalDivider(
                  thickness: 1,
                ),
                FlatButton(
                  child: Text("Set"),
                  onPressed: () => {
                    if (loggingPeriodisInt)
                      {
                        context
                            .read<SettingsCubit>()
                            .setLoggingPeriod(loggingPeriod),
                        Navigator.pop(context),
                      },
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget SetWifiSSID(BuildContext context, state) {
  String ssid;

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "Set Wifi SSID",
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              style: TextStyle(
                fontSize: 20.0,
              ),
              maxLines: 1,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '${state.ssid}',
              ),
              onChanged: (String value) {
                ssid = value;
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
                VerticalDivider(
                  thickness: 1,
                ),
                FlatButton(
                  child: Text("Set"),
                  onPressed: () => {
                    context.read<SettingsCubit>().setWifiSSD(ssid),
                    Navigator.pop(context),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget SetWifiPassword(BuildContext context, state) {
  String password;

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28.0),
    ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text(
              "Set Wifi Password",
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              style: TextStyle(
                fontSize: 20.0,
              ),
              maxLines: 1,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '${state.password}',
              ),
              onChanged: (String value) {
                password = value;
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
                VerticalDivider(
                  thickness: 1,
                ),
                FlatButton(
                  child: Text("Set"),
                  onPressed: () => {
                    context.read<SettingsCubit>().setWifiPassword(password),
                    Navigator.pop(context),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

refreshOtherSetting(BuildContext context) async {
  await context.read<SettingsCubit>().getSDCardInfo();
  await context.read<SettingsCubit>().getBatteryInfo();
}
