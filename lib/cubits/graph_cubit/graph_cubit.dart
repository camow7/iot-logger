import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  List<List<FlSpot>> readings = [];
  List<FlSpot> temp = [];
  List<FlSpot> nepheloNTU = [];
  List<FlSpot> nepheloFNU = [];
  List<FlSpot> tu = [];
  GraphCubit() : super(Loading());
  double max;
  double min;

  loadGraph(String fileName) async {
    min = 0;
    max = 0;
    var directory = await getApplicationDocumentsDirectory();

    await File('${directory.path}/$fileName').readAsLines().then(
      (List<String> lines) {
        for (int i = 1; i < lines.length; i++) {
          print(lines[i]);
          List<String> readingsList = lines[i].split(",");
          if (readingsList.length == 6) {
            // Check for new max temp
            if (double.parse(readingsList[2]) > max) {
              max = double.parse(readingsList[2]);
            }

            //Check for new min
            if (double.parse(readingsList[3]) < min) {
              min = double.parse(readingsList[3]);
            }

            //Check for new min
            if (double.parse(readingsList[5]) < min) {
              min = double.parse(readingsList[5]);
            }

            temp.add(FlSpot(
                double.parse(readingsList[0].substring(11, 13) +
                    "." +
                    readingsList[0].substring(14, 16)),
                double.parse(readingsList[2])));
            nepheloNTU.add(FlSpot(
                double.parse(readingsList[0].substring(11, 13) +
                    "." +
                    readingsList[0].substring(14, 16)),
                double.parse(readingsList[3])));
            nepheloFNU.add(FlSpot(
                double.parse(readingsList[0].substring(11, 13) +
                    "." +
                    readingsList[0].substring(14, 16)),
                double.parse(readingsList[4])));
            tu.add(FlSpot(
                double.parse(readingsList[0].substring(11, 13) +
                    "." +
                    readingsList[0].substring(14, 16)),
                double.parse(readingsList[5])));
            // print(readingsList[0].substring(11, 13) +
            //     "." +
            //     readingsList[0].substring(14, 16));
          }
        }
      },
    );

    readings = [temp, nepheloNTU, nepheloFNU, tu];

    print("Min: ${min * -1.2} Max: ${max * 1.2}");

    emit(Loaded(readings: readings, min: min, max: max));
  }
}
