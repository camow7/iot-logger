import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sensor_logs_state.dart';

class SensorLogsCubit extends Cubit<SensorLogsState> {
  SensorLogsCubit() : super(SensorLogsInitial(showLogs: false));

  void showLogs() => emit(SensorLogsDisplay(showLogs: true));
  void hideLogs() => emit(SensorLogsDisplay(showLogs: false));
}
