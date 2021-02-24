import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  ArduinoRepository _arduinoRepository;
  String ssid = "";
  String password = "";
  String remainingSpace = "";
  String usedSpace = "";
  String batteryVoltage = "";
  String batteryADC = "";
  String loggingPeriod = "";
  String time = "";

  SettingsCubit(this._arduinoRepository) : super(LoadingSettings());

  getAllSettings() async {
    print("get All settings");
    await getBatteryInfo();
    await getSDCardInfo();
    await getLoggingPeriod();
    await getRTCTime();
    await getWifiDetails();

    emit(Loaded(
        remainingSpace: this.remainingSpace,
        usedSpace: this.usedSpace,
        batteryADC: this.batteryADC,
        batteryVoltage: this.batteryVoltage,
        loggingPeriod: this.loggingPeriod,
        time: this.time,
        ssid: this.ssid,
        password: this.password));
  }

  void refresh() {
    print("settings updated");
    emit(Loaded(
        remainingSpace: this.remainingSpace,
        usedSpace: this.usedSpace,
        batteryADC: this.batteryADC,
        batteryVoltage: this.batteryVoltage,
        loggingPeriod: this.loggingPeriod,
        time: this.time,
        ssid: this.ssid,
        password: this.password));
  }

  getRTCTime() async {
    print("getting current time");
    _arduinoRepository.getRTCTime();
    time = await _arduinoRepository.settingStreamController.stream.first;
    refresh();
  }

  getLoggingPeriod() async {
    print("getting logging period");
    _arduinoRepository.getLoggingPeriod();
    loggingPeriod =
        await _arduinoRepository.settingStreamController.stream.first;

    refresh();
  }

  getSDCardInfo() async {
    print("getting SD Card info");
    _arduinoRepository.getSDCardInfo();
    String value =
        await _arduinoRepository.settingStreamController.stream.first;

    List<String> result = value.split(",");
    remainingSpace = result[0];
    usedSpace = result[1];
    refresh();
  }

  getWifiDetails() async {
    print("getting Wifi info");
    _arduinoRepository.getWifiDetails();
    String value =
        await _arduinoRepository.settingStreamController.stream.first;

    List<String> result = value.split(",");
    ssid = result[0];
    password = result[1];
    refresh();
  }

  getBatteryInfo() async {
    print("getting battery info");
    _arduinoRepository.getBatteryInfo();

    String value =
        await _arduinoRepository.settingStreamController.stream.first;

    List<String> batteryInfoString = value.split(",");
    batteryADC = batteryInfoString[0];
    batteryVoltage = batteryInfoString[1];
    refresh();
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
    getRTCTime();
  }
}
