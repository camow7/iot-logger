import 'package:flutter/material.dart';
import 'package:iot_logger/widgets/graph_item.dart';

import '../shared/layout.dart';
import '../shared/main_card.dart';
import '../shared/refresh_button.dart';
import '../shared/sub_card.dart';

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final readingName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      body: Layout(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(),
            MainCard(
              ListTile(
                title: Text(
                  readingName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            SubCard(
              Column(
                children: [
                  Text(
                    'Last Reading',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '5.2',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
            Container(height: 300, padding: EdgeInsets.all(10), child: GraphItem()), // graph
            RefreshButton(null)
          ],
        ),
      ),
    );
  }
}
