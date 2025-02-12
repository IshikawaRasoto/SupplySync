part of 'user_request_bloc.dart';

@immutable
sealed class UserRequestState {}

final class UserRequestInitial extends UserRequestState {}

final class UserRequestLoading extends UserRequestState {}

final class UserRequestFailure extends UserRequestState {
  final String message;
  UserRequestFailure(this.message);
}

final class UserRequestUserSuccess extends UserRequestState {
  final User user;
  UserRequestUserSuccess(this.user);
}

final class UserRequestAllUsersSuccess extends UserRequestState {
  final List<User> users;
  UserRequestAllUsersSuccess(this.users);
}
