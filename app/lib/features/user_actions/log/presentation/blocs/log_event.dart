part of 'log_bloc.dart';

@immutable
sealed class LogEvent {}

class FetchLogs extends LogEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? level;
  final String? source;

  FetchLogs({
    this.startDate,
    this.endDate,
    this.level,
    this.source,
  });
}
