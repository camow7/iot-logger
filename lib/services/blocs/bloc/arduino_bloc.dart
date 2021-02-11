import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';

import 'package:iot_logger/models/arduino_repository.dart';
import 'package:iot_logger/models/message.dart';
import 'package:meta/meta.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:udp/udp.dart';
import 'dart:io' show Platform;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:async/async.dart';

part 'arduino_event.dart';
part 'arduino_state.dart';

class ArduinoBloc extends Bloc<ArduinoEvent, ArduinoState> {
  final ArduinoRepository _arduinoRepository;

  StreamSubscription _subscription;
  StreamSubscription _heartBeatStreamSubscription;
  Stream heartBeatStream;
  final Connectivity _connectivity = Connectivity();
  String wifiName, wifiIP;
  bool isConnectedToWifi = false;
  int destinationPort = 2506;
  InternetAddress destinationIP = InternetAddress("10.0.0.1");
  Timer timer;

  ArduinoBloc(this._arduinoRepository) : super(ArduinoInitial());

  @override
  Stream<ArduinoState> mapEventToState(ArduinoEvent event) async* {
    if (event is InitialiseConnection) {
      if (Platform.isAndroid) {
        WiFiForIoTPlugin.forceWifiUsage(true);
      }
      print("Initialising Wifi Connex`ction...");

      _subscription = _connectivity.onConnectivityChanged.listen(
        (status) async {
          print('Connection Change Detected');

          try {
            wifiName = await WifiInfo().getWifiName();
            wifiIP = await WifiInfo().getWifiIP();

            // If Wifi is connected
            if (wifiIP != null) {
              isConnectedToWifi = true;
              print('Wifi Connected: $wifiName $wifiIP');

              _arduinoRepository.initialiseConnection(wifiIP);

              add(ConnectionChanged(ArduinoConnected()));
            } else {
              //No Wifi Found
              isConnectedToWifi = false;
              print('No Wifi Detected');
              add(ConnectionChanged(ArduinoDisconnected()));
            }
          } catch (e) {
            print("No Connections Found");
            print(e.toString());
          }
        },
      );
    } else if (event is GetLoggingPeriod) {
      _arduinoRepository.getLoggingPeriod();
      yield ArduinoConnected();
    } else if (event is GetBatteryInfo) {
      _arduinoRepository.getBatteryInfo();
      yield ArduinoConnected();
    } else if (event is SetRTCTime) {
      _arduinoRepository.setRTCTime();
      yield ArduinoConnected();
    } else if (event is GetRTCTime) {
      _arduinoRepository.getRTCTime();
      yield ArduinoConnected();
    } else if (event is SetLoggingPeriod) {
      _arduinoRepository.setLoggingPeriod(event.loggingPeriod);
      yield ArduinoConnected();
    } else if (event is GetLogsList) {
      _arduinoRepository.getLogsList();
      yield ArduinoConnected();
    } else if (event is GetSDCardInfo) {
      _arduinoRepository.getSDCardInfo();
      yield ArduinoConnected();
    } else if (event is GetLogFile) {
      _arduinoRepository.getLogFile(event.logFileName);
      yield ArduinoConnected();
    } else if (event is ConnectionChanged) {
      // print(event.connection);
      // if (event.connection is ArduinoConnected) {
      //   print('Starting Heart Beat');
      // } else {
      //   print('Wifi Disconnected');
      // }
      yield event.connection;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
