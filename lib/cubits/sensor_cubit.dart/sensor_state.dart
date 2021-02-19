part of 'sensor_cubit.dart';

@immutable
abstract class SensorState {
  const SensorState();
}

class Connected extends SensorState {
  const Connected() : super();
}

class Disconnected extends SensorState {
  const Disconnected() : super();
}
