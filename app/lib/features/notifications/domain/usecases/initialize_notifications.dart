import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/notification_repository.dart';

class InitializeNotifications implements UseCase<void, Unit> {
  final NotificationRepository _repository;

  InitializeNotifications(this._repository);

  @override
  Future<Either<Failure, void>> call(Unit param) async {
    return right(await _repository.initialize());
  }
}
