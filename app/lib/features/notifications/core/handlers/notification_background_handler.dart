import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import '../../data/datasources/notification_local_data_source.dart';
import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final localNotifications =
      LocalNotificationsDataSourceImpl(notificationsPlugin);

  await localNotifications.showNotification(
    NotificationMessage(
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      channel: NotificationChannel.system,
      payload: message.data,
    ),
  );
  Logger().i('Handling a background message: ${message.messageId}');
}
