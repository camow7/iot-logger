import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/sensor.dart';

class SensorCubit extends Cubit<DeviceState> {
  SensorCubit() : super(DeviceState.Loaded);

  void reload() {
    emit(DeviceState.Refreshing);
    new Timer(new Duration(seconds: 5), () {
      print('5 secs');
      emit(DeviceState.Loaded);
    });
  }
}
