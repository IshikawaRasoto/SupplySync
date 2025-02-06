import 'package:fpdart/fpdart.dart';
import 'package:supplysync/core/error/failure.dart';

import '../entities/notification_channel.dart';
import '../entities/notification_message.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  Future<void> showNotification(NotificationMessage message);
  Future<String?> getFirebaseToken();
  Future<void> updateFirebaseToken(
      {required String firebaseToken, required String jwtToken});
  Future<Either<Failure, bool?>> getChannelEnabledState(
      NotificationChannel channel);
  Future<Either<Failure, void>> saveChannelEnabledState(
      NotificationChannel channel, bool enabled);
}
