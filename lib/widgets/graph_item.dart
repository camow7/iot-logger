import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                mainData(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
  }

  LineChartData mainData() {
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
                return '2:00';
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
      lineBarsData: [
        LineChartBarData(
          spots: [
            // graph plots
            FlSpot(1, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(12, 0),
            FlSpot(12.5, 1),
          ],
          isCurved: true,
          colors: [const Color(0xff00D381)],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
