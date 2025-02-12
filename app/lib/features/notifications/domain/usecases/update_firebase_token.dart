import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/notification_repository.dart';

class UpdateFirebaseToken implements UseCase<Unit, UpdateFirebaseParams> {
  final NotificationRepository _repository;

  UpdateFirebaseToken(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateFirebaseParams token) async {
    try {
      await _repository.updateFirebaseToken(
          firebaseToken: token.firebaseToken, jwtToken: token.jwtToken);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

class UpdateFirebaseParams {
  final String firebaseToken;
  final String jwtToken;

  UpdateFirebaseParams({required this.firebaseToken, required this.jwtToken});
}
