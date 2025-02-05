import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_message.dart';
import '../repositories/notification_repository.dart';

class ShowNotification implements UseCase<Unit, NotificationMessage> {
  final NotificationRepository _repository;

  ShowNotification(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NotificationMessage param) async {
    await _repository.showNotification(param);
    return right(unit);
  }
}
