part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartRequestSuccess extends CartState {}

final class CartRequestFailure extends CartState {
  final Failure failure;
  CartRequestFailure(this.failure);
}

final class CartDetailsSuccess extends CartState {
  final Cart cart;
  CartDetailsSuccess(this.cart);
}

final class AllCartsSuccess extends CartState {
  final List<Cart> carts;
  AllCartsSuccess(this.carts);
}
