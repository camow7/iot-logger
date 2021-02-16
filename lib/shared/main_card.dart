import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget content;  
  const MainCard({this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      elevation: 5,
      child: content
    );
  }
}
