part of 'sensor_cubit.dart';

@immutable
abstract class SensorState {
  final String sensorID = "Sensor";
  const SensorState();
}

class Connected extends SensorState {
  final String sensorID;
  const Connected(this.sensorID) : super();
}

class Disconnected extends SensorState {
  final List<NetworkInterface> networks;
  final bool networkFound;
  final String sensorID;
  const Disconnected(this.sensorID, this.networks, this.networkFound) : super();
}

// Inital State
class Loading extends SensorState {
  final String sensorID;
  const Loading(this.sensorID) : super();
}
