import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final Function refreshHandler;
  const RefreshButton(this.refreshHandler);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: refreshHandler,
          child: Text(
            'Refresh',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'Montserrat'),
          ),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(35),
          elevation: 3,
          textColor: Theme.of(context).backgroundColor,
        ),
      ],
    );
  }
}
