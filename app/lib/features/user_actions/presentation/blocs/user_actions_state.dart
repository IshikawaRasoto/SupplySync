part of 'user_actions_bloc.dart';

@immutable
abstract class UserActionsState {}

final class UserInitial extends UserActionsState {}

final class UserLoading extends UserActionsState {}

final class UserActionsSuccess extends UserActionsState {
  final String message;
  UserActionsSuccess(this.message);
}

final class UserFailure extends UserActionsState {
  final String message;
  UserFailure(this.message);
}
