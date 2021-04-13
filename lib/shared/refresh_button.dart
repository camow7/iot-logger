import 'package:flutter/material.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton();

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
          onPressed: () => context.read<SensorCubit>().refresh(),
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
