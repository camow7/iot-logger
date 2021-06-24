import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_logger/models/SensorReading.dart';
import 'package:iot_logger/services/arduino_repository.dart';

part 'sensor_reading_state.dart';

class SensorReadingCubit extends Cubit<SensorReadingState> {
  ArduinoRepository _arduinoRepository;
  Timer measurementRequestTimer;
  List<List<SensorReading>> readings = [];
  List<SensorReading> temp = [];
  List<SensorReading> pH = [];
  List<SensorReading> nepheloNTU = [];
  List<SensorReading> nepheloFNU = [];
  List<SensorReading> tu = [];
  int counter = 0;

  SensorReadingCubit(this._arduinoRepository) : super(Loading());

  refresh() {
    emit(
      Loaded(
        readings: this.readings,
      ),
    );
  }

  getReadings() async {
    _arduinoRepository.getCurrentMeasurements(2);

    String tempString = await _arduinoRepository
        .currentMeasurementsStreamController.stream.first;

    List<String> readingsList = tempString.split(",");
    int numberOfReadings = readingsList.length;

    // if Turbidity Sensor
    if (numberOfReadings == 4) {
      // add readings to array
      this.temp.insert(0, SensorReading(readingsList[0], "Temp C"));
      this.nepheloNTU.insert(0, SensorReading(readingsList[1], "Nephelo NTU"));
      this.nepheloFNU.insert(0, SensorReading(readingsList[2], "Nephelo FNU"));
      this.tu.insert(0, SensorReading(readingsList[3], "TU mg/l"));

      // keep only 60 readings (only a minutes worth of readings)
      if (this.temp.length > 60) {
        this.temp.removeLast();
        this.nepheloNTU.removeLast();
        this.nepheloFNU.removeLast();
        this.tu.removeLast();
      }
      this.readings = [temp, nepheloNTU, nepheloFNU, tu];
    } else if (numberOfReadings == 1) {
      // if pH Sensor
      this.pH.insert(0, SensorReading(readingsList[0], "pH"));

      while (this.pH.length > 60) {
        this.pH.removeLast();
      }

      this.readings = [pH];
    }

    refresh();
  }

  getCurrentMeasurements() async {
    // Send initial reading request
    await getReadings();

    // Send repeating reading request every 1 second
    measurementRequestTimer =
        new Timer.periodic(Duration(seconds: 1), (Timer t) async {
      await getReadings();
    });
  }

  // Stop timer
  closeTimer() {
    counter = 0;
    measurementRequestTimer.cancel();
    emit(Loading());
  }
}
