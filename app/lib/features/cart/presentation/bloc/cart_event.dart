part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class CartUseRequested extends CartEvent {
  final String jwtToken;
  final String load;
  final String loadQuantity;
  final String destination;
  final String origin;

  CartUseRequested({
    required this.jwtToken,
    required this.load,
    required this.loadQuantity,
    required this.destination,
    required this.origin,
  });
}

final class CartShutdownRequested extends CartEvent {
  final String id;
  CartShutdownRequested(this.id);
}

final class CartMaintenanceRequested extends CartEvent {
  final String id;
  CartMaintenanceRequested(this.id);
}

final class CartDetailsRequested extends CartEvent {
  final String id;
  CartDetailsRequested(this.id);
}

final class CartLoadAllRequested extends CartEvent {}
