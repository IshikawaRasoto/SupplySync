part of 'log_bloc.dart';

@immutable
abstract class LogState {
  const LogState();
}

class LogInitial extends LogState {}

class LogsLoading extends LogState {}

class LogsLoaded extends LogState {
  final List<Log> logs;

  const LogsLoaded(this.logs);
}

class LogsError extends LogState {
  final String message;

  const LogsError(this.message);
}
