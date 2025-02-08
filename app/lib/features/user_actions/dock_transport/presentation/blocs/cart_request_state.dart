part of 'cart_request_bloc.dart';

@immutable
sealed class CartRequestState {}

final class CartRequestInitial extends CartRequestState {}

final class CartRequestInProgress extends CartRequestState {}

final class CartRequestCartDetailsSuccess extends CartRequestState {
  final Cart cart;

  CartRequestCartDetailsSuccess(this.cart);
}

final class CartRequestCartDetailsFailure extends CartRequestState {
  final String message;

  CartRequestCartDetailsFailure(this.message);
}

final class CartRequestSuccess extends CartRequestState {}

final class CartRequestFailure extends CartRequestState {
  final String message;

  CartRequestFailure(this.message);
}
