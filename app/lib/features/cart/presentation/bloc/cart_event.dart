part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

final class CartUseRequested extends CartEvent {
  final String id;
  CartUseRequested(this.id);
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
