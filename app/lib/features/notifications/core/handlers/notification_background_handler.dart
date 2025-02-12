import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    if (kDebugMode) {
      Logger().d(
          'Handling a background message id: ${message.messageId}\nTitle: ${message.notification?.title}\n Channel: ${message.notification?.android?.channelId}\nData: ${message.data}');
    }
  } catch (e, stackTrace) {
    Logger().e('Error in firebaseMessagingBackgroundHandler: $e',
        error: e, stackTrace: stackTrace);
  }
}
