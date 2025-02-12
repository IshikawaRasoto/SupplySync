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

class CartReportProblemEvent extends CartRequestEvent {
  final String problemDescription;

  CartReportProblemEvent(this.problemDescription);
}

class ReleaseCartRequested extends CartRequestEvent {}

class ResetCartRequestEvent extends CartRequestEvent {}
