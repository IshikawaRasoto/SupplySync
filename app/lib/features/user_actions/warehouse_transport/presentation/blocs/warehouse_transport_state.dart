part of 'warehouse_transport_bloc.dart';

@immutable
abstract class WarehouseTransportState {
  final List<Cart> incomingDrones;
  final String? error;

  const WarehouseTransportState({
    this.incomingDrones = const [],
    this.error,
  });
}

class WarehouseTransportInitial extends WarehouseTransportState {
  const WarehouseTransportInitial() : super();
}

class WarehouseTransportLoading extends WarehouseTransportState {
  const WarehouseTransportLoading() : super();
}

class WarehouseTransportSuccess extends WarehouseTransportState {
  const WarehouseTransportSuccess({required super.incomingDrones});
}

class WarehouseTransportFailure extends WarehouseTransportState {
  const WarehouseTransportFailure({required super.error});
}
