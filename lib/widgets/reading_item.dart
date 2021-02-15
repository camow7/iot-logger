import 'package:flutter/material.dart';

class ReadingItem extends StatelessWidget {
  final String name;
  const ReadingItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 5,
      ),
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Center(
              child: Text(
                name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            trailing: Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }
}
