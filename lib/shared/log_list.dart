import 'package:flutter/material.dart';

class LogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: 
        // sensor.logs.length > 0 && sensor.state == DeviceState.Loaded
        //     ? 
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Past Logs'),
                  // const SizedBox(width: 5),
                  // SvgPicture.asset('assets/svgs/toggle-arrow.svg'),
                ],
              )
            // : const Text('No Logs'),
      ),
    );
  }
}
