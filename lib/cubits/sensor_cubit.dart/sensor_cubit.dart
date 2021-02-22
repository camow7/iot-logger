import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final ArduinoRepository _arduinoRepository;
  StreamSubscription<bool> _isConnectedSubscription;

  SensorCubit(
    this._arduinoRepository,
  ) : super(Disconnected());

  void connect() {
    //print("connect triggered");
    _isConnectedSubscription =
        _arduinoRepository.isConnectedStream.listen((value) {
      if (value == true) {
        // print("State Switched To Connected");
        emit(Connected());
      } else {
        // print("State Switched To Disconnected");
        emit(Disconnected());
      }
    });
  }

  // Not used at the moment
  void refresh() {
    _arduinoRepository.initialiseWifiConnection();
  }
}
