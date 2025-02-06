part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationInitialized extends NotificationState {}

final class NotificationTokenUpdated extends NotificationState {}

class NotificationChannelStatesLoaded extends NotificationState {
  final Map<NotificationChannel, bool> channelStates;

  NotificationChannelStatesLoaded(this.channelStates);
}

final class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
