import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget content;
  const MainCard({this.content});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: isLandscape
          ? MediaQuery.of(context).size.width * 0.4
          : double.infinity,
      height: isLandscape
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.15,
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          elevation: 5,
          child: Center(child: content)),
    );
  }
}
