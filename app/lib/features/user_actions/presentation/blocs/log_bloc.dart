import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../domain/use_cases/get_logs.dart';
import 'log_state.dart';
import 'log_event.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final GetLogs _getLogs;
  final UserCubit _userCubit;

  LogBloc({
    required GetLogs getLogs,
    required UserCubit userCubit,
  })  : _getLogs = getLogs,
        _userCubit = userCubit,
        super(LogInitial()) {
    on<FetchLogs>(_onFetchLogs);
  }

  Future<void> _onFetchLogs(FetchLogs event, Emitter<LogState> emit) async {
    emit(LogsLoading());

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const LogsError('User not authenticated'));
      return;
    }

    final result = await _getLogs(
      GetLogsParams(
        jwtToken: currentUser.jwtToken,
        startDate: event.startDate,
        endDate: event.endDate,
        level: event.level,
        source: event.source,
      ),
    );

    result.fold(
      (failure) => emit(LogsError(failure.message)),
      (logs) => emit(LogsLoaded(logs)),
    );
  }
}
