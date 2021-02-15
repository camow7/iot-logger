import 'package:flutter/material.dart';

class ReadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 10,
      ),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Center(
                child: Text(
              'Turb 1',
              style: Theme.of(context).textTheme.headline5,
            )),
            trailing: Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }
}
