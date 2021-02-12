import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubits/log_download/log_download_cubit.dart';
import '../models/sensor.dart';

class LogItems extends StatelessWidget {
  final Log log;
  const LogItems(this.log);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogDownloadCubit(),
      child: _LogItem(log),
    );
  }
}

class _LogItem extends StatelessWidget {
  final Log log;
  const _LogItem(this.log);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogDownloadCubit, LogDownloadState>(builder: (_, state) {
      // print('${state.date}, ${state.progress}, ${state.status}, ${state.icon}');
      // print('${log.progress}, ${log.logState}');
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        child: logTile(context, state),
      );
    });
  }

  Widget logTile(BuildContext context, LogDownloadState state) {
    return Stack(
      children: [
        LinearProgressIndicator(
          minHeight: 60,
          value: state.progress,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        ListTile(
          leading: folderIcon(context, state),
          title: logDate(context, state),
          trailing: IconButton(
            icon: state.icon,
            onPressed: () => context.read<LogDownloadCubit>().download(),
          ),
        )
      ],
    );
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
          style: TextStyle(
            fontSize: 10,
          ),
        )
      ],
    );
  }

  Widget logDate(BuildContext context, LogDownloadState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // text changes color depending on loading progress bar length
        formatText(
          DateFormat.E().format(log.date),
          state.progress > 0.2 ? Colors.white : Color.fromRGBO(36, 136, 104, 1),
        ),
        formatText(
          DateFormat.yMd().format(log.date),
          state.progress > 0.4 ? Colors.white : Theme.of(context).accentColor,
        )
      ],
    );
  }

  Text formatText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
