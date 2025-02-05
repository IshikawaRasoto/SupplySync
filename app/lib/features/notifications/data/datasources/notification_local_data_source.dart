import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/web.dart';

import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';

abstract class LocalNotificationsDataSource {
  Future<void> initialize();
  Future<void> showNotification(NotificationMessage message);
}

class LocalNotificationsDataSourceImpl implements LocalNotificationsDataSource {
  final FlutterLocalNotificationsPlugin _notifications;
  final Logger _logger = Logger();

  LocalNotificationsDataSourceImpl(this._notifications);

  @override
  Future<void> initialize() async {
    try {
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      );

      await _notifications.initialize(initializationSettings);
      await _createNotificationChannels();
      _logger.i('Local notifications initialized');
    } catch (e) {
      _logger.e('Error initializing notifications: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    for (var channel in NotificationChannel.values) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              channel.id,
              channel.name,
              description: channel.description,
              importance: Importance.high,
            ),
          );
    }
  }

  @override
  Future<void> showNotification(NotificationMessage message) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        message.channel.id,
        message.channel.name,
        channelDescription: message.channel.description,
        importance: Importance.high,
        priority: Priority.high,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.hashCode,
        message.title,
        message.body,
        NotificationDetails(android: androidDetails),
        payload: message.payload?.toString(),
      );

      _logger.d('Notification shown: $message.title');
    } catch (e) {
      _logger.e('Error showing notification: $e');
      rethrow;
    }
  }
}
