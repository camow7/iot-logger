import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/layout.dart';
import '../shared/refresh_button.dart';
import '../widgets/graph_item_from_file.dart';

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
        content: isLandscape
            ? SingleChildScrollView(
                child: pageContent(context),
              )
            : pageContent(context),
      ),
    );
  }

  Widget pageContent(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    String fileName = arguments['fileName'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              fileName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Container(
          //color: Colors.blue[50],
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.4,
          margin: EdgeInsets.only(top: 20),
          child: GraphItemFromFile(fileName),
        ),
      ],
    );
  }
}
