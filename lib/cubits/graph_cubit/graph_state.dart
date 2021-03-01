part of 'graph_cubit.dart';

@immutable
abstract class GraphState {
  const GraphState();
}

class Loading extends GraphState {
  const Loading() : super();
}

class Loaded extends GraphState {
  final List<List<FlSpot>> readings;
  final double min, max;
  const Loaded({this.readings, this.max, this.min}) : super();
}

class CannotLoad extends GraphState {}
