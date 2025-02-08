part of 'cart_request_bloc.dart';

@immutable
sealed class CartRequestEvent {}

class RequestCartInformationRequested extends CartRequestEvent {
  final String cartId;

  RequestCartInformationRequested(this.cartId);
}

class CartPhotoSubmitted extends CartRequestEvent {
  final XFile photo;

  CartPhotoSubmitted(this.photo);
}
