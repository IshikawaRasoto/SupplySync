part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String username;
  final String password;
  AuthLogin({required this.username, required this.password});
}

final class AuthLogout extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}
