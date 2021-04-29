import 'package:flutter/material.dart';
import 'package:iot_logger/cubits/sensor_cubit.dart/sensor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton();

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      height: MediaQuery.of(context).size.height * 0.1,
      // color: Colors.blue,
      child: ElevatedButton(
        onPressed: () => context.read<SensorCubit>().refresh(),
        style: ElevatedButton.styleFrom(
          elevation: 3,
          primary: Theme.of(context).primaryColor, // background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          padding: isLandscape
              ? const EdgeInsets.symmetric(horizontal: 55)
              : const EdgeInsets.all(35),
        ),
        child: Text(
          'Refresh',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.02,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat'),
        ),
      ),
    );
  }
}
