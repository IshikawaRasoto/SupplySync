import 'notification_channel.dart';

class NotificationMessage {
  final String title;
  final String body;
  final NotificationChannel channel;
  final Map<String, dynamic>? payload;

  const NotificationMessage({
    required this.title,
    required this.body,
    required this.channel,
    this.payload,
  });
}
