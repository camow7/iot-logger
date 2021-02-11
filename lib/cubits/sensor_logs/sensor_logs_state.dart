part of 'sensor_logs_cubit.dart';

@immutable
abstract class SensorLogsState {
  final bool showLogs;
  const SensorLogsState({this.showLogs});
}

class SensorLogsInitial extends SensorLogsState {
  const SensorLogsInitial({bool showLogs})
      : super(showLogs: showLogs);
}

class SensorLogsDisplay extends SensorLogsState {
  const SensorLogsDisplay({bool showLogs})
      : super(showLogs: showLogs);
}
