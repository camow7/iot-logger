import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final ArduinoRepository _arduinoRepository;

  SensorCubit(this._arduinoRepository) : super(Disconnected());

  void connect() {
    _arduinoRepository.isConnectedStream.listen((value) {
      if (value == true) {
        emit(Connected());
      } else {
        emit(Disconnected());
      }
    });
  }

  void refresh() {
    print("Refreshing in cubit");
    _arduinoRepository.closeConnections();
    _arduinoRepository.initialiseWifiConnection();
  }
}
