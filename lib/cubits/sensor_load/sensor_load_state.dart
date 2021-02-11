part of 'sensor_load_cubit.dart';

@immutable
abstract class SensorLoadState {
  final double progress;
  final DeviceState deviceState;
  
  const SensorLoadState({this.progress, this.deviceState});
}

class SensorInitial extends SensorLoadState {
  const SensorInitial({double progress, DeviceState deviceState})
      : super(progress: progress, deviceState: deviceState);
}

class SensorRefresh extends SensorLoadState {
  const SensorRefresh({double progress, DeviceState deviceState})
      : super(progress: progress, deviceState: deviceState);
}