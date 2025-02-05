import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';
import '../../domain/usecases/get_firebase_tolen.dart';
import '../../domain/usecases/initialize_notifications.dart';
import '../../domain/usecases/show_notification.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required InitializeNotifications initializeNotifications,
    required ShowNotification showNotification,
    required GetFirebaseToken getFirebaseToken,
  })  : _initializeNotifications = initializeNotifications,
        _showNotification = showNotification,
        _getFirebaseToken = getFirebaseToken,
        super(NotificationInitial());

  final InitializeNotifications _initializeNotifications;
  final ShowNotification _showNotification;
  final GetFirebaseToken _getFirebaseToken;

  Future<void> initialize() async {
    try {
      await _initializeNotifications(unit);
      emit(NotificationInitialized());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required NotificationChannel channel,
    Map<String, dynamic>? payload,
  }) =>
      _showNotification(
        NotificationMessage(
          title: title,
          body: body,
          channel: channel,
          payload: payload,
        ),
      );

  Future<String?> getFirebaseToken() async {
    try {
      final response = await _getFirebaseToken(unit);
      return response.fold(
        (l) => null,
        (r) => r,
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
      return null;
    }
  }
}
