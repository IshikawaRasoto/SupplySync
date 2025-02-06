import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/log.dart';
import '../repositories/log_repository.dart';

class GetLogsParams {
  final String jwtToken;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? level;
  final String? source;

  GetLogsParams({
    required this.jwtToken,
    this.startDate,
    this.endDate,
    this.level,
    this.source,
  });
}

class GetLogs implements UseCase<List<Log>, GetLogsParams> {
  final LogRepository _repository;

  GetLogs(this._repository);

  @override
  Future<Either<Failure, List<Log>>> call(GetLogsParams params) async {
    return await _repository.getLogs(
      jwtToken: params.jwtToken,
      startDate: params.startDate,
      endDate: params.endDate,
      level: params.level,
      source: params.source,
    );
  }
}
