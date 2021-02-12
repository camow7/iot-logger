part of 'log_download_cubit.dart';

@immutable
abstract class LogDownloadState {
  final String date;
  final double progress;
  final LogStatus status;
  final Widget icon;

  const LogDownloadState({this.date, this.progress, this.status, this.icon});
}

class LogInitial extends LogDownloadState {
  const LogInitial({String date, double progress, LogStatus status, Widget icon})
      : super(date: date, progress: progress, status: status, icon: icon);
}

class LogDownloading extends LogDownloadState {
  const LogDownloading({String date, double progress, LogStatus status, Widget icon})
      : super(date: date, progress: progress, status: status, icon: icon);
}

class LogDownloaded extends LogDownloadState {
  const LogDownloaded({String date, double progress, LogStatus status, Widget icon})
      : super(date: date, progress: progress, status: status, icon: icon);
}

class LogViewing extends LogDownloadState {
  const LogViewing({String date, double progress, LogStatus status, Widget icon})
      : super(date: date, progress: progress, status: status, icon: icon);
}