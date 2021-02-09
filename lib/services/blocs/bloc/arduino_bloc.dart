import 'dart:async';
import 'dart:convert';
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
  InternetAddress destinationIP =
      InternetAddress("10.0.0.1"); //InternetAddress("127.0.0.1");
  Timer timer;

  ArduinoBloc(this._arduinoRepository) : super(ArduinoInitial());

  @override
  Stream<ArduinoState> mapEventToState(ArduinoEvent event) async* {
    if (event is InitialiseConnection) {
      if (Platform.isAndroid) {
        WiFiForIoTPlugin.forceWifiUsage(true);
      }
      print("Initialising Wifi Connection...");

      _subscription = _connectivity.onConnectivityChanged.listen(
        (status) async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          print('Connection Change Detected');

          //Try Get Wifi IP and Name
          try {
            wifiName = await WifiInfo().getWifiName();
            wifiIP = await WifiInfo().getWifiIP();

            if (wifiIP != null) {
              //Wifi Connected
              isConnectedToWifi = true;
              print('Wifi Connected: $wifiName $wifiIP');

              RawDatagramSocket.bind(InternetAddress(wifiIP), 4444)
                  .then((RawDatagramSocket socket) {
                print('UDP Server: ${socket.address.address}:${socket.port}');

                // Send Heart Beat
                Timer.periodic(Duration(seconds: 1), (Timer t) {
                  List<int> data = [0xFE, 1, t.tick, 0, 0, 1];
                  print('SENT: [0xFE, 1, ${t.tick}, 0, 0, 1]');
                  socket.send(data, InternetAddress("10.0.0.1"), 2506);
                });

                //Listen for response
                socket.listen((event) {
                  Datagram d = socket.receive();
                  if (d == null) return;
                  print('RECEIVED: ${d.address.address}:${d.port}: ${d.data}');
                  _arduinoRepository.readMessage(d.data);
                });
              });

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
    } else if (event is GetFile) {
      try {
        yield MessageLoading();
        final message = await _arduinoRepository.fetchMessage(event.fileName);
        yield MessageLoaded(message);
      } on Exception {
        //MessageError(Message("Error"));
      }
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
