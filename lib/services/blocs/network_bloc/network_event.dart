import 'package:iot_logger/services/blocs/network_bloc/network_state.dart';

abstract class NetworkEvent {}

//Event called on at beginning of app
class ListenConnection extends NetworkEvent {}

//Event called on when connection changes
class ConnectionChanged extends NetworkEvent {
  NetworkState connection;
  ConnectionChanged(this.connection);
}
