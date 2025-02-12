import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/cubit/user/user_cubit.dart';
import '../../domain/entities/notification_channel.dart';
import '../../domain/entities/notification_message.dart';
import '../../domain/usecases/get_firebase_tolen.dart';
import '../../domain/usecases/initialize_notifications.dart';
import '../../domain/usecases/show_notification.dart';
import '../../domain/usecases/update_firebase_token.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required InitializeNotifications initializeNotifications,
    required ShowNotification showNotification,
    required GetFirebaseToken getFirebaseToken,
    required UpdateFirebaseToken updateFirebaseToken,
    required UserCubit userCubit,
  })  : _initializeNotifications = initializeNotifications,
        _showNotification = showNotification,
        _getFirebaseToken = getFirebaseToken,
        _updateFirebaseToken = updateFirebaseToken,
        _userCubit = userCubit,
        super(NotificationInitial());

  final InitializeNotifications _initializeNotifications;
  final ShowNotification _showNotification;
  final GetFirebaseToken _getFirebaseToken;
  final UpdateFirebaseToken _updateFirebaseToken;
  final UserCubit _userCubit;

  Map<NotificationChannel, bool> channelEnabledStates = {};

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

  Future<void> updateToken() async {
    try {
      final jwtToken = _userCubit.getToken();
      if (jwtToken == null) {
        emit(NotificationError('User not authenticated'));
        return;
      }
      final firebaseToken = await getFirebaseToken();
      if (firebaseToken != null) {
        final result = await _updateFirebaseToken(
          UpdateFirebaseParams(
            firebaseToken: firebaseToken,
            jwtToken: jwtToken,
          ),
        );
        result.fold(
          (failure) => emit(NotificationError(failure.message)),
          (_) => emit(NotificationTokenUpdated()),
        );
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
