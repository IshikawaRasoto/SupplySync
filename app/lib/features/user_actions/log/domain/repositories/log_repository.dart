import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../entities/log.dart';

abstract class LogRepository {
  Future<Either<Failure, List<Log>>> getLogs({
    required String jwtToken,
    DateTime? startDate,
    DateTime? endDate,
    String? level,
    String? source,
  });
}
