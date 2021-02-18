import 'package:flutter/material.dart';

import '../shared/layout.dart';
import '../shared/main_card.dart';
import '../shared/refresh_button.dart';
import '../shared/sub_card.dart';
import '../widgets/graph_item.dart';

class GraphScreen extends StatelessWidget {
  void refreshPage() {
    print('refreshing graph screen');
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: Layout(
        content: isLandscape ? SingleChildScrollView(child: pageContent(context),): pageContent(context),
      ),
    );
  }

  Widget pageContent(BuildContext context) {
    final readingName = ModalRoute.of(context).settings.arguments as String;
    return Column(
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
              width: MediaQuery.of(context).size.width * 0.9,
              margin: EdgeInsets.only(top:20),
              child: GraphItem(),
            ),
            RefreshButton(refreshPage)
          ],
        );
  }
}
