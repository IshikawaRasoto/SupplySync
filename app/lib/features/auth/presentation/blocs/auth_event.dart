part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthResetEvent extends AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String username;
  final String password;
  final String firebaseToken;
  AuthLogin({
    required this.username,
    required this.password,
    required this.firebaseToken,
  });
}

final class AuthLogout extends AuthEvent {}

final class AuthGetCurrentUser extends AuthEvent {}
