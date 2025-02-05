import '../entities/notification_message.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  Future<void> showNotification(NotificationMessage message);
  Future<String?> getFirebaseToken();
}
