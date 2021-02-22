part of 'graph_cubit.dart';

@immutable
abstract class GraphState {
  const GraphState();
}

class Loading extends GraphState {
  const Loading() : super();
}

class Loaded extends GraphState {
  final List<List<dynamic>> data;
  const Loaded({this.data}) : super();
}

class CannotLoad extends GraphState {}
