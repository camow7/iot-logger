part of 'arduino_bloc.dart';

@immutable
abstract class ArduinoEvent {}

class InitialiseConnection extends ArduinoEvent {}

class ConnectionChanged extends ArduinoEvent {
  final ArduinoState connection;
  ConnectionChanged(this.connection);
}

class GetFile extends ArduinoEvent {
  final String fileName;
  GetFile(this.fileName);
}
