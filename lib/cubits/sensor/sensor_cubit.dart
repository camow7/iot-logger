import 'package:bloc/bloc.dart';
import 'package:iot_logger/models/sensor.dart';
import 'package:meta/meta.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  SensorCubit()
      : super(SensorInitial(progress: 0, deviceState: DeviceState.Loaded));

  void refresh() => emit(SensorRefresh(
        progress: _increment(state.progress),
        deviceState: DeviceState.Refreshing,
      ));

  void complete() => emit(SensorRefresh(
        progress: 0,
        deviceState: DeviceState.Loaded,
      ));

  double _increment(val) {
    val += 0.2;
    return val;
  }
}
