import 'package:iot_logger/services/blocs/network_bloc/network_state.dart';

abstract class NetworkEvent {}

// Event which starts the listenning of network changes (only called once at the beginning of app)
class ListenConnection extends NetworkEvent {}

// Event called whenever the connection status of the devices changes
class ConnectionChanged extends NetworkEvent {
  NetworkState connection;
  ConnectionChanged(this.connection);
}
