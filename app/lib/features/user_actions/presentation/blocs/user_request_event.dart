part of 'user_request_bloc.dart';

@immutable
sealed class UserRequestEvent {}

class GetUserByUserName extends UserRequestEvent {
  final String userName;
  GetUserByUserName(this.userName);
}

class GetAllUsers extends UserRequestEvent {
  GetAllUsers();
}
