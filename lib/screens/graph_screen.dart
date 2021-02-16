import 'package:flutter/material.dart';
import 'package:iot_logger/widgets/graph_item.dart';

import '../shared/layout.dart';
import '../shared/main_card.dart';
import '../shared/refresh_button.dart';
import '../shared/sub_card.dart';

class GraphScreen extends StatelessWidget {
  void refreshPage() {
    print('refreshing graph screen');
  }

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
              content: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  readingName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            SubCard(
              content: Column(
                children: [
                  Text(
                    'Last Reading',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '5.2',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: GraphItem(),
            ),
            RefreshButton(refreshPage)
          ],
        ),
      ),
    );
  }
}
