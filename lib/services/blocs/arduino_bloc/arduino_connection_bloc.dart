import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'arduino_connection_event.dart';
part 'arduino_connection_state.dart';

class ArduinoConnectionBloc
    extends Bloc<ArduinoConnectionEvent, ArduinoConnectionState> {
  ArduinoConnectionBloc() : super(ArduinoConnectionInitial());

  @override
  Stream<ArduinoConnectionState> mapEventToState(
    ArduinoConnectionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
