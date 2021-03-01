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
  const Loaded({this.readings}) : super();
}

class CannotLoad extends GraphState {}
