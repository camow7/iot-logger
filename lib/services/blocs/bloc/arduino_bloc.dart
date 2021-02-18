import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:iot_logger/models/StateMessage.dart';

import 'package:iot_logger/models/arduino_repository.dart';
import 'package:meta/meta.dart';

part 'arduino_event.dart';
part 'arduino_state.dart';

class ArduinoBloc extends Bloc<ArduinoEvent, ArduinoState> {
  final ArduinoRepository _arduinoRepository;

  StreamSubscription<StateMessage> _messageSubscription;
  StreamSubscription<bool> _heartbeatSubscription;
  Stream heartBeatStream;
  final Connectivity _connectivity = Connectivity();
  String wifiName, wifiIP;
  bool isConnectedToWifi = false;
  int destinationPort = 2506;
  InternetAddress destinationIP = InternetAddress("10.0.0.1");
  Timer timer;
  int connectionCounter = 0;
  //Future<String> fileName = 'test.txt';

  ArduinoBloc(this._arduinoRepository) : super(ArduinoInitial());

  @override
  Stream<ArduinoState> mapEventToState(ArduinoEvent event) async* {
    if (event is InitialiseConnection) {
      _heartbeatSubscription =
          _arduinoRepository.heartBeatStream.listen((value) {
        print("HeartBeat Received");
      });
      yield ArduinoConnected();
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
      _messageSubscription = _arduinoRepository.messageStream.listen((message) {
        print("Download: " + message.percentage.toString());
        if (message.percentage >= 100.0) {
          _messageSubscription.cancel();
        }
      });
      yield ArduinoConnected();
    } else if (event is ConnectionChanged) {
      yield event.connection;
    } else if (event is GetCurrentMeasurements) {
      _arduinoRepository.getCurrentMeasurements(event.decimalPlaces);
      yield ArduinoConnected();
    } else if (event is DeleteLogFile) {
      _arduinoRepository.deleteLogFile(event.fileName);
      yield ArduinoConnected();
    } else if (event is SetWifiSSID) {
      _arduinoRepository.setWifiSSID(event.ssid);
      yield ArduinoConnected();
    } else if (event is SetWifiPassword) {
      _arduinoRepository.setWifiPassword(event.password);
      yield ArduinoConnected();
    }
  }
}
