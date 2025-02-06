import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/server_exception.dart';
import '../../domain/entities/log.dart';
import '../../domain/repositories/log_repository.dart';
import '../source/user_actions_remote_data_source.dart';

class LogRepositoryImpl implements LogRepository {
  final UserActionsRemoteDataSource _remoteDataSource;

  LogRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Log>>> getLogs({
    required String jwtToken,
    DateTime? startDate,
    DateTime? endDate,
    String? level,
    String? source,
  }) async {
    try {
      final logs = await _remoteDataSource.getLogs(
        jwtToken: jwtToken,
        startDate: startDate,
        endDate: endDate,
        level: level,
        source: source,
      );
      return right(logs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
