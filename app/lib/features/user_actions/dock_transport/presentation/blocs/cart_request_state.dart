part of 'cart_request_bloc.dart';

@immutable
abstract class CartRequestState {}

class CartRequestInitial extends CartRequestState {}

class CartRequestInProgress extends CartRequestState {}

class CartRequestSuccess extends CartRequestState {}

class CartRequestFailure extends CartRequestState {
  final String message;

  CartRequestFailure(this.message);
}

class CartRequestCartDetailsSuccess extends CartRequestState {
  final Cart cart;

  CartRequestCartDetailsSuccess(this.cart);
}

class CartReleased extends CartRequestState {}
