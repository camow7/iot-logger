part of 'arduino_bloc.dart';

@immutable
abstract class ArduinoEvent {}

class InitialiseConnection extends ArduinoEvent {}

class ConnectionChanged extends ArduinoEvent {
  final ArduinoState connection;
  ConnectionChanged(this.connection);
}

class GetLoggingPeriod extends ArduinoEvent {}

class SetLoggingPeriod extends ArduinoEvent {
  final int loggingPeriod;
  SetLoggingPeriod(this.loggingPeriod);
}

class GetBatteryInfo extends ArduinoEvent {}

class SetRTCTime extends ArduinoEvent {}

class GetRTCTime extends ArduinoEvent {}

class GetLogsList extends ArduinoEvent {}

class GetSDCardInfo extends ArduinoEvent {}

class GetLogFile extends ArduinoEvent {
  final String logFileName;
  GetLogFile(this.logFileName);
}
