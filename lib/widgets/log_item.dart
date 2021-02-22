import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_logger/services/arduino_repository.dart';
import '../cubits/log_download/log_download_cubit.dart';

class LogItem extends StatelessWidget {
  final String fileName;
  final ArduinoRepository arduinoRepository;
  const LogItem(this.fileName, this.arduinoRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogDownloadCubit(arduinoRepository), // add fileName
      child: _LogItem(fileName: fileName),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String fileName;
  const _LogItem({this.fileName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogDownloadCubit, LogDownloadState>(builder: (_, state) {
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        child: InkWell(
          onTap: () => null, // routeToReadings(context, state),
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: logTile(context, state, fileName),
          ),
        ),
      );
    });
  }

  Widget logTile(
      BuildContext context, LogDownloadState state, String fileName) {
    if (state is LogDownloaded) {
      return GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed('/graph-reading', arguments: {'fileName': fileName}),
        child: Container(
          child: Stack(
            children: [
              LinearProgressIndicator(
                minHeight: double.infinity,
                value: state.progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              ListTile(
                leading: folderIcon(context, state),
                title: logDate(context, state, fileName),
                trailing: IconButton(
                  icon: state.icon,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => context.read<LogDownloadCubit>().downloadFile(fileName),
        child: Container(
          child: Stack(
            children: [
              LinearProgressIndicator(
                minHeight: double.infinity,
                value: state.progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
              ListTile(
                  leading: folderIcon(context, state),
                  title: logDate(context, state, fileName),
                  trailing: IconButton(icon: state.icon, onPressed: () => {}))
            ],
          ),
        ),
      );
    }
  }

  Widget folderIcon(BuildContext context, LogDownloadState state) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Icon(
          Icons.folder,
          color:
              state.progress > 0 ? Colors.white : Theme.of(context).accentColor,
          size: 40,
        ),
        Text(
          '${(state.progress * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }

  Widget logDate(
      BuildContext context, LogDownloadState state, String fileName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // text changes color depending on loading progress bar length
        formatText(
          context,
          fileName,
          Theme.of(context).focusColor,
        ),
        // formatText(
        //   context,
        //   fileName,
        //   state.progress > 0.4 ? Colors.white : Theme.of(context).accentColor,
        // )
      ],
    );
  }

  Text formatText(BuildContext context, String text, Color color) {
    return Text(
      text,
      // style: Theme.of(context).textTheme.headline4,
      style: TextStyle(
          color: color,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontFamily: 'Montserrat'),
    );
  }
}
