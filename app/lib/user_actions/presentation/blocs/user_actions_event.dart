part of 'user_actions_bloc.dart';

@immutable
abstract class UserActionsEvent {}

class ChangeUserProfile extends UserActionsEvent {
  final String targetUserName;
  final String? newName;
  final String? newEmail;
  ChangeUserProfile({
    required this.targetUserName,
    this.newName,
    this.newEmail,
  });
}

class ChangeUserPassword extends UserActionsEvent {
  final String targetUserName;
  final String oldPassword;
  final String newPassword;
  ChangeUserPassword({
    required this.targetUserName,
    required this.oldPassword,
    required this.newPassword,
  });
}
