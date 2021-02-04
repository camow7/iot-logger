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
          ),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(30),
          elevation: 3,
          textColor: Theme.of(context).backgroundColor,
        ),
      ],
    );
  }
}
