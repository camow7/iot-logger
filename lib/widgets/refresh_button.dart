import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  void refresh() {
    print('refresh sensors');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          onPressed: () => refresh(),
          child: const Text(
            'Refresh',
            style: TextStyle(color: Colors.white),
          ),
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(40),
          elevation: 3,
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
