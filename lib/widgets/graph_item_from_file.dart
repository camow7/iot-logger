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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: LineChart(
                    mainData(context, state.readings),
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

  LineChartData mainData(BuildContext context, List<List<FlSpot>> readings) {
    return LineChartData(
      backgroundColor: Theme.of(context).accentColor,
      gridData: FlGridData(
        show: true,
        horizontalInterval: 22,
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
            if (((value % 3 == 0)) || value == 0) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24.00,
      minY: 0,
      maxY: 30,
      lineBarsData: linesBarData(readings),
    );
  }

  List<LineChartBarData> linesBarData(List<List<FlSpot>> readings) {
    final LineChartBarData tempLine = LineChartBarData(
      spots: readings[0],
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData nepheloNTULine = LineChartBarData(
      spots: readings[1],
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData nepheloFNULine = LineChartBarData(
      spots: readings[2],
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    final LineChartBarData tuLine = LineChartBarData(
      spots: readings[3],
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [tempLine, nepheloNTULine, nepheloFNULine, tuLine];
  }
}
