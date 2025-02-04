part of 'log_bloc.dart';

@immutable
abstract class LogState {}

class LogInitial extends LogState {}

class LogsLoading extends LogState {}

class LogsLoaded extends LogState {
  final List<Log> logs;

  LogsLoaded(this.logs);
}

class LogsError extends LogState {
  final String message;

  LogsError(this.message);
}
