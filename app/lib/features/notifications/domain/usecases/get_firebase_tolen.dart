import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/failure.dart';
import '../repositories/notification_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetFirebaseToken implements UseCase<String?, Unit> {
  final NotificationRepository _repository;

  GetFirebaseToken(this._repository);
  @override
  Future<Either<Failure, String?>> call(Unit param) async {
    return right(await _repository.getFirebaseToken());
  }
}
