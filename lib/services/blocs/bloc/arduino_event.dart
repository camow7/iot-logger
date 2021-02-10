part of 'arduino_bloc.dart';

@immutable
abstract class ArduinoEvent {}

class InitialiseConnection extends ArduinoEvent {}

class ConnectionChanged extends ArduinoEvent {
  final ArduinoState connection;
  ConnectionChanged(this.connection);
}

class GetLoggingPeriod extends ArduinoEvent {
  //final String loggingPeriod;
  //GetFile(this.loggingPeriod);
}
