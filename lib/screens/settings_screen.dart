import 'package:flutter/material.dart';
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
            Container(
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
                                  "Sensor's Current Time: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
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
                              ),
                              ListTile(
                                title: Center(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    child: RaisedButton(
                                      color: Colors.blue,
                                      child: Text(
                                        "Set Logging Period",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              )
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
                                  "Battery Info: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "SD Card Info: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }
}
