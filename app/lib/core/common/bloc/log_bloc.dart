import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../entities/log.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  LogBloc() : super(LogInitial()) {
    on<FetchLogs>(_onFetchLogs);
  }

  Future<void> _onFetchLogs(FetchLogs event, Emitter<LogState> emit) async {
    emit(LogsLoading());

    // Simulated log data
    final logs = [
      Log(
        timestamp: DateTime.now(),
        level: 'INFO',
        source: 'USER',
        message: 'User logged in successfully.',
      ),
      Log(
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        level: 'WARNING',
        source: 'SERVER',
        message: 'High CPU usage detected.',
      ),
      Log(
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        level: 'ERROR',
        source: 'SERVER',
        message: 'Failed to connect to database.',
      ),
    ];

    emit(LogsLoaded(logs));
  }
}
