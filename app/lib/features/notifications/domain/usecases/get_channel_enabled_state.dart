import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_channel.dart';
import '../repositories/notification_repository.dart';

class GetChannelEnabledState implements UseCase<bool?, NotificationChannel> {
  final NotificationRepository _repository;

  GetChannelEnabledState(this._repository);

  @override
  Future<Either<Failure, bool?>> call(NotificationChannel channel) async {
    return _repository.getChannelEnabledState(channel);
  }
}
