import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final Function refreshHandler;
  const RefreshButton(this.refreshHandler);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: refreshHandler,
          child: Text(
            'Refresh',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat'),
          ),
          shape: isLandscape ? Border() : CircleBorder(),
          padding: isLandscape
              ? const EdgeInsets.symmetric(horizontal: 55)
              : const EdgeInsets.all(35),
          elevation: 3,
          textColor: Theme.of(context).backgroundColor,
        ),
      ],
    );
  }
}
