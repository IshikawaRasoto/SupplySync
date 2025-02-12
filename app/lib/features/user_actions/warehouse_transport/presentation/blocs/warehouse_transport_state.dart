part of 'warehouse_transport_bloc.dart';

@immutable
sealed class WarehouseTransportState {
  const WarehouseTransportState();
}

class WarehouseTransportInitial extends WarehouseTransportState {
  const WarehouseTransportInitial();
}

class WarehouseTransportLoading extends WarehouseTransportState {
  const WarehouseTransportLoading();
}

class WarehouseTransportSuccess extends WarehouseTransportState {
  final List<Cart> incomingDrones;
  final List<Warehouse> warehouses;

  const WarehouseTransportSuccess({
    required this.incomingDrones,
    required this.warehouses,
  });
}

class WarehouseTransportFailure extends WarehouseTransportState {
  final String? error;

  const WarehouseTransportFailure({this.error});
}
