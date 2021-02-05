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

class MessageLoaded extends ArduinoState {
  final Message message;
  const MessageLoaded(
    this.message,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MessageLoaded && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class MessageError extends ArduinoState {
  final Message message;
  const MessageError(
    this.message,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MessageError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
