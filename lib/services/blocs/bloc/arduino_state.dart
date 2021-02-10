part of 'arduino_bloc.dart';

@immutable
abstract class ArduinoState {
  const ArduinoState();
}

class ArduinoInitial extends ArduinoState {
  const ArduinoInitial();
}

class ArduinoConnected extends ArduinoState {
  const ArduinoConnected();
}

class ArduinoDisconnected extends ArduinoState {
  const ArduinoDisconnected();
}

class MessageLoading extends ArduinoState {
  const MessageLoading();
}

class MessageSent extends ArduinoState {
  const MessageSent();
}
