part of 'log_cubit.dart';

@immutable
abstract class LogState {
  final double progress;
  final LogStatus status;
  final Widget icon;

  const LogState({this.progress, this.status, this.icon});

  @override
  List<Object> get props => [progress, status, icon];
}

class LogInitial extends LogState {
  const LogInitial({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}

class LogDownloading extends LogState {
  const LogDownloading({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}

class LogDownloaded extends LogState {
  const LogDownloaded({double progress, LogStatus status, Widget icon})
      : super(progress: progress, status: status, icon: icon);
}