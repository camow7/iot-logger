import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:iot_logger/models/arduino_repository.dart';
import 'package:iot_logger/models/message.dart';
import 'package:iot_logger/services/blocs/network_bloc/network_state.dart';
import 'package:meta/meta.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

part 'arduino_event.dart';
part 'arduino_state.dart';

class ArduinoBloc extends Bloc<ArduinoEvent, ArduinoState> {
  final ArduinoRepository _arduinoRepository;
  StreamSubscription _subscription;
  final Connectivity _connectivity = Connectivity();
  String wifiName, wifiIP;
  bool isConnectedToWifi = false;

  ArduinoBloc(this._arduinoRepository) : super(ArduinoInitial());

  @override
  Stream<ArduinoState> mapEventToState(ArduinoEvent event) async* {
    if (event is InitialiseConnection) {
      print("Initialising Wifi Connection...");

      _subscription = _connectivity.onConnectivityChanged.listen(
        (status) async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          print('Connection Change Detected: $connectivityResult');

          //Try Get Wifi IP and Name
          try {
            wifiName = await WifiInfo().getWifiName();
            wifiIP = await WifiInfo().getWifiIP();

            if (wifiIP != null) {
              //Wifi Connected
              isConnectedToWifi = true;
              print('Wifi Connected: $wifiName $wifiIP');
              //Start Making Heart Beat calls
              add(ConnectionChanged(ArduinoConnected()));
            } else {
              //No Wifi Found
              isConnectedToWifi = false;
              print('Wifi Disconnected');
              add(ConnectionChanged(ArduinoDisconnected()));
            }
          } catch (e) {
            print("No Connections Found");
            print(e.toString());
          }
        },
      );
    } else if (event is GetFile) {
      try {
        yield MessageLoading();
        final message = await _arduinoRepository.fetchMessage(event.fileName);
        yield MessageLoaded(message);
      } on Exception {
        MessageError(Message("Error"));
      }
    } else if (event is ConnectionChanged) {
      print(event.connection);
      if (event.connection is ArduinoConnected) {
        print('Starting Heart Beat');
      } else {
        print('Wifi Disconnected');
      }
      yield event.connection;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
