import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/notification_channel.dart';
import '../cubit/notification_cubit.dart';

class NotificationSettingsDialog extends StatefulWidget {
  // Alterado para StatefulWidget para gerenciar estado
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  NotificationSettingsDialog({
    super.key,
  });

  @override
  State<NotificationSettingsDialog> createState() =>
      _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState
    extends State<NotificationSettingsDialog> {
  final Logger _logger = Logger();

  Future<void> _openChannelSettings(
      BuildContext context, String channelId) async {
    try {
      await const MethodChannel('supplysync/notifications')
          .invokeMethod('openChannelSettings', {'channelId': channelId});
    } catch (e) {
      _logger.e("Erro ao abrir configurações do canal: $e");
    }
  }

  Future<void> _openNotificationSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        Map<NotificationChannel, bool> channelEnabledStates = {};
        if (state is NotificationChannelStatesLoaded) {
          channelEnabledStates = state.channelStates;
        }
        return AlertDialog(
          title: const Text('Notification Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...NotificationChannel.values.map(
                (channel) => ListTile(
                  title: Text(channel.name),
                  subtitle: Text(channel.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () =>
                            context.read<NotificationCubit>().showNotification(
                                  title: 'Test ${channel.name}',
                                  body:
                                      'This is a test notification for ${channel.description}',
                                  channel: channel,
                                ),
                      ),
                      Switch(
                          value: channelEnabledStates[channel] ?? true,
                          onChanged: (newValue) => context
                              .read<NotificationCubit>()
                              .updateChannelEnabledState(channel, newValue)),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        tooltip:
                            'Configurações Avançadas do Canal', // Tooltip para melhor UX
                        onPressed: () =>
                            _openChannelSettings(context, channel.id),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: _openNotificationSettings,
                child: const Text(
                    'Configurações Avançadas do Sistema'), // Texto mais claro
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
      },
    );
  }
}
