import '../../../domain/entities/warehouse_product.dart';

sealed class WarehouseProductsState {
  const WarehouseProductsState();
}

class WarehouseProductsInitial extends WarehouseProductsState {
  const WarehouseProductsInitial();
}

class WarehouseProductsLoading extends WarehouseProductsState {
  const WarehouseProductsLoading();
}

class WarehouseProductsLoaded extends WarehouseProductsState {
  final List<WarehouseProduct> products;

  const WarehouseProductsLoaded(this.products);
}

class WarehouseProductOperationLoading extends WarehouseProductsState {
  const WarehouseProductOperationLoading();
}

class WarehouseProductOperationSuccess extends WarehouseProductsState {
  final String message;

  const WarehouseProductOperationSuccess(this.message);
}

class WarehouseProductsError extends WarehouseProductsState {
  final String message;

  const WarehouseProductsError(this.message);
}
