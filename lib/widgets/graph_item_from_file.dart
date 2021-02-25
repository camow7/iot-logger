import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/graph_cubit/graph_cubit.dart';

class GraphItemFromFile extends StatelessWidget {
  final String fileName;
  GraphItemFromFile(this.fileName);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GraphCubit, GraphState>(
      cubit: GraphCubit()..loadGraph(fileName),
      builder: (_, state) {
        if (state is Loaded) {
          return Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Theme.of(context).accentColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    child: LineChart(
                      mainData(state.data),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: const Text(
                  'Turbidity',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Stack(
            children: <Widget>[
              Center(
                child: Container(
                  // color: Colors.blue[50],
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.width * 0.40,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  LineChartData mainData(rowsAsListOfValues) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0x44EBEDF4),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
              const TextStyle(color: Color(0xffffffff), fontSize: 10),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '2';
              case 4:
                return '4:00';
              case 6:
                return '6:00';
              case 8:
                return '8:00';
              case 10:
                return '10:00';
              case 12:
                return '12:00';
              case 14:
                return '14:00';
              case 16:
                return '16:00';
              case 18:
                return '18:00';
              case 20:
                return '20:00';
              case 22:
                return '22:00';
              case 24:
                return '24:00';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 1,
      maxX: 24,
      minY: 0,
      maxY: 6,
      lineBarsData: linesBarData(rowsAsListOfValues),
    );
  }
}

List<LineChartBarData> linesBarData(rowsAsListOfValues) {
  final LineChartBarData tempData = LineChartBarData(
    spots: [FlSpot(1, 1)],
    isCurved: true,
    colors: [
      const Color(0xff4af699),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData nepheloNTUData = LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
    isCurved: false,
    colors: [
      const Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      const Color(0x00aa4cfc),
    ]),
  );
  final LineChartBarData nepheloFNUData = LineChartBarData(
    spots: [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),
    ],
    isCurved: true,
    colors: const [
      Color(0xff27b6fc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  return [
    tempData,
    nepheloNTUData,
    nepheloFNUData,
  ];
}
