import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/models/arduino_repository.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/logs_screen.dart';

ArduinoRepository arduinoRepo = ArduinoRepository();

void main() => runApp(
      MultiProvider(
        providers: [
          //Create
          BlocProvider(
            create: (context) =>
                ArduinoBloc(arduinoRepo)..add(InitialiseConnection()),
          ),
        ],
        child: IotLoggerApp(),
      ),
    );

class IotLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Logger',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(108, 194, 130, 1),
        accentColor: const Color.fromRGBO(57, 68, 76, 1),
        backgroundColor: Colors.white,
        buttonColor: const Color.fromRGBO(108, 194, 130, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
            headline1: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            bodyText2:
                const TextStyle(color: const Color.fromRGBO(57, 68, 76, 1))),
      ),
      routes: {
        '/': (ctx) => HomeScreen(),
        '/logs': (ctx) => LogsScreen(),
      },
    );
  }
}
