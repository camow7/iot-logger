part of 'log_download_cubit.dart';

@immutable
abstract class LogDownloadState {
  final double progress;
  final LogStatus status;
  final Widget icon;

  const LogDownloadState({this.progress, this.status, this.icon});
}

class LogInitial extends LogDownloadState {
  const LogInitial({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}

class LogDownloading extends LogDownloadState {
  const LogDownloading({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}

class LogDownloaded extends LogDownloadState {
  const LogDownloaded({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}