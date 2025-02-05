part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationInitialized extends NotificationState {}

final class NotificationTokenUpdated extends NotificationState {}

final class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
