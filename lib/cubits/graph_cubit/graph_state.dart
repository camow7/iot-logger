part of 'graph_cubit.dart';

@immutable
abstract class GraphState {
  const GraphState();
}

class Loading extends GraphState {
  const Loading() : super();
}

class LoadedTurbidity extends GraphState {
  final List<List<FlSpot>> readings;
  final double tempMax;
  final double tempMin;
  final double nepheloNTUMax;
  final double nepheloNTUMin;
  final double nepheloFNUMax;
  final double nepheloFNUMin;
  final double tuMax;
  final double tuMin;
  const LoadedTurbidity({
    this.readings,
    this.tempMax,
    this.tempMin,
    this.nepheloNTUMax,
    this.nepheloNTUMin,
    this.nepheloFNUMax,
    this.nepheloFNUMin,
    this.tuMax,
    this.tuMin,
  }) : super();
}

class LoadedPH extends GraphState {
  final List<List<FlSpot>> readings;
  final double phMax;
  final double phMin;
  const LoadedPH({
    this.readings,
    this.phMax,
    this.phMin,
  }) : super();
}

class CannotLoad extends GraphState {}
