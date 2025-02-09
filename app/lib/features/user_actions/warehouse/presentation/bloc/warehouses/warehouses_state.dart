import '../../../domain/entities/warehouse.dart';

sealed class WarehousesState {
  const WarehousesState();
}

class WarehousesInitial extends WarehousesState {
  const WarehousesInitial();
}

class WarehousesLoading extends WarehousesState {
  const WarehousesLoading();
}

class WarehousesLoaded extends WarehousesState {
  final List<Warehouse> warehouses;

  const WarehousesLoaded(this.warehouses);
}

class WarehousesError extends WarehousesState {
  final String message;

  const WarehousesError(this.message);
}
