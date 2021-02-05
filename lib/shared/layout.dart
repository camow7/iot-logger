import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/services/blocs/bloc/arduino_bloc.dart';
import 'package:iot_logger/services/blocs/network_bloc/network_bloc.dart';
import 'package:iot_logger/services/blocs/network_bloc/network_state.dart';

class Layout extends StatelessWidget {
  final Widget content;

  const Layout(this.content);

  Widget get saphiLogo {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          child: SvgPicture.asset(
            'assets/svgs/saphi-logo-white-text.svg',
            width: 150,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/land.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.topRight,
            child: BlocBuilder<ArduinoBloc, ArduinoState>(
              builder: (context, state) {
                if (state is ArduinoInitial)
                  return Text("Initiating Connection");
                else if (state is ArduinoConnected)
                  return Icon(
                    Icons.wifi,
                    size: 40,
                  );
                else
                  return Icon(
                    Icons.wifi_off,
                    size: 40,
                  );
                // To call bloc event (i.e GetFile)
                // void submitCityName(BuildContext context, String fileName) {
                // final arduinoBloc = context.bloc<ArduinoBloc>();
                // arduinoBloc.add(GetFile(cityName));
                // }
              },
            ),
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       [
        //         Color.fromRGBO(0, 0, 0, 0.3),
        //         Colors.transparent,
        //       ],
        //       begin: Alignment.topCenter,
        //       end: Alignment.center,
        //     ),
        //   ),
        // ),
        Container(
          child: Column(
            children: [
              saphiLogo,
              Container(
                //height: 700,
                child: content,
              ),
            ],
          ),
        )
      ],
    );
  }
}
