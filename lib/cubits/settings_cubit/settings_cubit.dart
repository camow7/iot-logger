import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  ArduinoRepository _arduinoRepository;
  String wifiName;
  String password;

  SettingsCubit(this._arduinoRepository) : super(Loaded());

  getSDCardInfo() {
    _arduinoRepository.getSDCardInfo();
  }

  setWifiSSD(String name) {
    _arduinoRepository.setWifiSSID(name);
  }

  setWifiPassword(String password) {
    _arduinoRepository.setWifiPassword(password);
  }

  getArduinoTime() {
    _arduinoRepository.getRTCTime();
  }

  setArduinoTime() {
    _arduinoRepository.setRTCTime();
  }

  getBatteryInfo() {
    _arduinoRepository.getBatteryInfo();
  }
}
