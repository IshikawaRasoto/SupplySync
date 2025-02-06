import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:supplysync/core/common/cubit/user/user_cubit.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/constants.dart';
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
  late User _user;
  String firebaseToken = '';

  @override
  void initState() {
    super.initState();
    _user = (context.read<UserCubit>().state as UserLoggedIn).user;
  }

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
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationError) {
          showSnackBar(
            context,
            message: 'Erro: ${state.message}',
            isError: true,
          );
        }
      },
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
              if (_user.roles.contains(UserRoles.admin))
                TextButton(
                  onPressed: () => context
                      .read<NotificationCubit>()
                      .getFirebaseToken()
                      .then((value) {
                    setState(
                        () => firebaseToken = value ?? 'Erro ao obter token');
                  }),
                  child: const Text('Pegar Token do Firebase'),
                ),
              if (_user.roles.contains(UserRoles.admin) &&
                  firebaseToken.isNotEmpty)
                SelectableText.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Firebase Token: '),
                      TextSpan(
                        text: firebaseToken,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () =>
                      Clipboard.setData(ClipboardData(text: firebaseToken)),
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
