import 'package:flutter/material.dart';
import '../shared/refresh_button.dart';
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
    return Scaffold(
      body: Layout(
        content: isLandscape
            ? SingleChildScrollView(child: pageContent(context, isLandscape))
            : pageContent(context, isLandscape),
      ),
    );
  }

  Widget pageContent(BuildContext context, bool isLandscape) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            BackButton(),
            SensorItem(),
            Container(
                height: MediaQuery.of(context).size.height * 0.38,
                child: GridView(
                  padding: EdgeInsets.only(top: 10),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: isLandscape ? 5.5 : 4.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    maxCrossAxisExtent: 500,
                  ),
                )),
          ],
        ),
        RefreshButton()
      ],
    );
  }
}
