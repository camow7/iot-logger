import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit() : super(Loading());

  loadGraph(String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    print('${directory.path}/$fileName');
    List<List<dynamic>> data;

    File('${directory.path}/$fileName').readAsString().then((String contents) {
      print(contents);
      data = const CsvToListConverter().convert(contents);
    });
    print(data);

    // List<List<dynamic>> contents = const CsvToListConverter().convert(data);

    emit(Loaded(data: data));
  }
}
