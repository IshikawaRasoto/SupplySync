import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:supplysync/features/notifications/data/datasources/notification_local_data_source.dart';

import '../../core/handlers/notification_background_handler.dart';
import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';

abstract class NotificationRemoteDataSource {
  Future<void> initialize();
  Future<void> showLocalNotification(NotificationMessage message);
  Future<String?> getFirebaseToken();
  Future<void> handleBackgroundMessage();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final LocalNotificationsDataSource _localNotifications;
  final FirebaseMessaging _firebaseMessaging;
  final Logger _logger = Logger();

  NotificationRemoteDataSourceImpl({
    required LocalNotificationsDataSource localNotifications,
    required FirebaseMessaging firebaseMessaging,
  })  : _localNotifications = localNotifications,
        _firebaseMessaging = firebaseMessaging;

  @override
  Future<void> initialize() async {
    await _requestPermissions();
    await _localNotifications.initialize();
    await _setupFirebaseMessaging();
    _logger.i('Firebase Notifications initialized');
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  @override
  Future<void> showLocalNotification(NotificationMessage message) =>
      _localNotifications.showNotification(message);

  @override
  Future<String?> getFirebaseToken() => _firebaseMessaging.getToken();

  void _handleForegroundMessage(RemoteMessage message) {
    _logger.i(
        'Handling foreground message: \n${message.notification?.title}\n${message.notification?.body}\n${message.data}');
    showLocalNotification(
      NotificationMessage(
        title: message.notification?.title ?? 'New Message',
        body: message.notification?.body ?? '',
        channel: NotificationChannel.system,
        payload: message.data,
      ),
    );
  }

  @override
  Future<void> handleBackgroundMessage() {
    return _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
