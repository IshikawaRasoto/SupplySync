import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/notification_channel.dart';

class NotificationSettingsDialog extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  NotificationSettingsDialog({
    super.key,
  });

  Future<void> _openChannelSettings(
      BuildContext context, String channelId) async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  Future<void> _openNotificationSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notification Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...NotificationChannel.values.map(
            (channel) => ListTile(
              title: Text(channel.name),
              subtitle: Text(channel.description),
              trailing: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _openChannelSettings(context, channel.id),
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: _openNotificationSettings,
            child: const Text('All Notification Settings'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
