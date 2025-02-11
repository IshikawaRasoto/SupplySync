part of 'cart_request_bloc.dart';

@immutable
abstract class CartRequestEvent {}

class RequestCartInformationRequested extends CartRequestEvent {
  final String cartId;

  RequestCartInformationRequested(this.cartId);
}

class CartPhotoSubmitted extends CartRequestEvent {
  final XFile photo;

  CartPhotoSubmitted(this.photo);
}

class ReleaseCartRequested extends CartRequestEvent {}

class ResetCartRequestEvent extends CartRequestEvent {}
