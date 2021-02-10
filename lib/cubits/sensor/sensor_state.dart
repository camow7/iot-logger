part of 'sensor_cubit.dart';

@immutable
abstract class SensorState {
  final double progress;
  final DeviceState deviceState;
  
  const SensorState({this.progress, this.deviceState});
}

class SensorInitial extends SensorState {
  const SensorInitial({double progress, DeviceState deviceState})
      : super(progress: progress, deviceState: deviceState);
}

class SensorRefresh extends SensorState {
  const SensorRefresh({double progress, DeviceState deviceState})
      : super(progress: progress, deviceState: deviceState);
}