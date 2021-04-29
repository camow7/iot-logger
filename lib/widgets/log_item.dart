import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot_logger/cubits/log_download_cubit/log_download_cubit.dart';
import 'package:iot_logger/services/arduino_repository.dart';
import 'package:iot_logger/shared/rive_animation.dart';

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
          onTap: () => null,
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
    if (state is LogLoaded) {
      // When file is loaded (Initial State)
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          context.read<LogDownloadCubit>().downloadFile(fileName);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.blue[50],
                // width: MediaQuery.of(context).size.width * 0.1,
                alignment: Alignment.center,
                child: Icon(
                  Icons.folder,
                  color: Theme.of(context).accentColor,
                  size: 40,
                ),
              ),
              Container(
                // color: Colors.blue[50],
                // width: MediaQuery.of(context).size.width * 0.45,
                // alignment: Alignment.center,
                child: logDate(context, state, fileName),
              ),
              Container(
                // color: Colors.blue[50],
                // width: MediaQuery.of(context).size.width * 0.1,
                // alignment: Alignment.right,
                child: SvgPicture.asset(
                  'assets/svgs/download.svg',
                ),
              ),
            ],
          ),
        ),
      );
    } else if (state is LogDownloading) {
      // When file is downloading
      return Container(
        child: Stack(
          children: [
            LinearProgressIndicator(
              minHeight: double.infinity,
              value: state.progress,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.blue[50],
                    // width: MediaQuery.of(context).size.width * 0.1,
                    alignment: Alignment.center,
                    child: folderIcon(context, state),
                  ),
                  Container(
                    // color: Colors.blue[50],
                    // width: MediaQuery.of(context).size.width * 0.45,
                    alignment: Alignment.center,
                    child: logDate(context, state, fileName),
                  ),
                  Container(
                    // color: Colors.blue[50],
                    width: MediaQuery.of(context).size.width * 0.03,
                    height: MediaQuery.of(context).size.width * 0.03,
                    alignment: Alignment.center,
                    child: RiveAnimation(),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      //When file is downloaded
      return GestureDetector(
        onTapDown: (TapDownDetails details) {
          Navigator.of(context)
              .pushNamed('/graph-reading', arguments: {'fileName': fileName});
        },
        child: Container(
          child: Stack(
            children: [
              Container(
                // width: MediaQuery.of(context).size.width * 0.8,
                // alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.1,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.folder,
                        color: Theme.of(context).accentColor,
                        size: 40,
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.45,
                      alignment: Alignment.center,
                      child: logDate(context, state, fileName),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.1,
                      alignment: Alignment.center,
                      child: Icon(Icons.done_outline),
                    ),
                  ],
                ),
              ),
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
        Text(
          '${(state.progress * 100).toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.subtitle2,
        )
      ],
    );
  }

  Widget logDate(
      BuildContext context, LogDownloadState state, String fileName) {
    return Text(
      fileName,
      style: TextStyle(
          color: Theme.of(context).focusColor,
          fontSize: 18,
          fontStyle: FontStyle.italic,
          fontFamily: 'Montserrat'),
    );
  }
}
