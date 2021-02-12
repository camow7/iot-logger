import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meta/meta.dart';

import '../../models/sensor.dart';
import '../../shared/rive_animation.dart';

part 'log_download_state.dart';

class LogDownloadCubit extends Cubit<LogDownloadState> {
  LogDownloadCubit()
      : super(
          LogInitial(
            progress: 0.0,
            status: LogStatus.Loaded,
            icon: SvgPicture.asset(
              'assets/svgs/download.svg',
            ),
          ),
        );

  void download() => emit(
        LogDownloading(
          progress: _increment(state.progress),
          status: LogStatus.Downloading,
          icon: RiveAnimation(),
        ),
      );

  void complete() => emit(
        LogDownloaded(
          progress: 0.0,
          status: LogStatus.Downloaded,
          icon: Icon(Icons.done_outline),
        ),
      );

  void view(String date) => emit(
        LogViewing(
          date: date,
          progress: 0.0,
          status: LogStatus.Viewing,
          icon: Container(),
        ),
      );

  double _increment(val) {
    val += 0.2;
    return val;
  }
}
