part of 'auth_credentials_cubit.dart';

@immutable
sealed class AuthCredentialsState {}

final class AuthCredentialsInitial extends AuthCredentialsState {}

final class AuthCredentialsLoaded extends AuthCredentialsState {
  final String? username;
  final String? password;
  final bool? savePassword;

  AuthCredentialsLoaded({this.username, this.password, this.savePassword});
}

final class AuthCredentialsSaved extends AuthCredentialsState {}
