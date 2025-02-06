import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_channel.dart';
import '../repositories/notification_repository.dart';

class SaveChannelEnabledState
    implements UseCase<void, SaveChannelEnabledParams> {
  final NotificationRepository _repository;

  SaveChannelEnabledState(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveChannelEnabledParams params) async {
    return _repository.saveChannelEnabledState(params.channel, params.enabled);
  }
}

class SaveChannelEnabledParams {
  final NotificationChannel channel;
  final bool enabled;

  SaveChannelEnabledParams({required this.channel, required this.enabled});
}
