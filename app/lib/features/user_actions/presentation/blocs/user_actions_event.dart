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

class RegisterNewUser extends UserActionsEvent {
  final String jwtToken;
  final String userName;
  final String name;
  final String email;
  final String password;
  final List<UserRoles> roles;
  RegisterNewUser({
    required this.jwtToken,
    required this.userName,
    required this.name,
    required this.email,
    required this.password,
    required this.roles,
  });
}
