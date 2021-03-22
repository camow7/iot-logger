import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/cubits/sensor_reading_cubit/sensor_reading_cubit.dart';
import 'package:iot_logger/shared/main_card.dart';
import '../shared/layout.dart';
import '../widgets/sensor_item.dart';

class ReadingsScreen extends StatelessWidget {
  void refreshPage() {
    print('refreshing readings screen');
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Layout(
      content: isLandscape
          ? SingleChildScrollView(child: pageContent(context, isLandscape))
          : pageContent(context, isLandscape),
    );
  }

  Widget pageContent(BuildContext context, bool isLandscape) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SensorItem(),
            BlocBuilder<SensorReadingCubit, SensorReadingState>(
              builder: (_, state) {
                if (state is Loaded) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.70,
                    child: ListView.builder(
                      itemCount: state.readings.length,
                      itemBuilder: (context, index) {
                        return MainCard(
                          content: InkWell(
                            onTap: () => {
                              Navigator.of(context).pushNamed(
                                  '/individual-sensor-screen',
                                  arguments: {'index': index}),
                            },
                            child: Center(
                              child: ListTile(
                                leading: Text(
                                    "${state.readings[index][0].sensorName}"),
                                trailing: Text(
                                    "${state.readings[index][0].sensorReading}"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else
                  //Loading Spinner
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                  );
              },
            )
          ],
        ),
      ],
    );
  }
}
