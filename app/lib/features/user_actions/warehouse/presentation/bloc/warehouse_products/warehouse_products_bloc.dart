import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/common/cubit/user/user_cubit.dart';
import '../../../domain/usecases/add_warehouse_product.dart';
import '../../../domain/usecases/get_warehouse_products.dart';
import '../../../domain/usecases/remove_warehouse_product.dart';
import '../../../domain/usecases/update_warehouse_product.dart';
import 'warehouse_products_event.dart';
import 'warehouse_products_state.dart';

class WarehouseProductsBloc
    extends Bloc<WarehouseProductsEvent, WarehouseProductsState> {
  final UserCubit _userCubit;
  final GetWarehouseProducts _getWarehouseProducts;
  final UpdateWarehouseProduct _updateWarehouseProduct;
  final AddWarehouseProduct _addWarehouseProduct;
  final RemoveWarehouseProduct _removeWarehouseProduct;

  WarehouseProductsBloc({
    required UserCubit userCubit,
    required GetWarehouseProducts getWarehouseProducts,
    required UpdateWarehouseProduct updateWarehouseProduct,
    required AddWarehouseProduct addWarehouseProduct,
    required RemoveWarehouseProduct removeWarehouseProduct,
  })  : _updateWarehouseProduct = updateWarehouseProduct,
        _getWarehouseProducts = getWarehouseProducts,
        _addWarehouseProduct = addWarehouseProduct,
        _removeWarehouseProduct = removeWarehouseProduct,
        _userCubit = userCubit,
        super(const WarehouseProductsInitial()) {
    on<GetWarehouseProductsEvent>(_onGetWarehouseProducts);
    on<RefreshWarehouseProductsEvent>(_onRefreshWarehouseProducts);
    on<UpdateWarehouseProductEvent>(_onUpdateWarehouseProduct);
    on<AddWarehouseProductEvent>(_onAddWarehouseProduct);
    on<RemoveWarehouseProductEvent>(_onRemoveWarehouseProduct);
  }

  Future<void> _onGetWarehouseProducts(
    GetWarehouseProductsEvent event,
    Emitter<WarehouseProductsState> emit,
  ) async {
    emit(const WarehouseProductsLoading());

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseProductsError('User not authenticated'));
      return;
    }

    final result = await _getWarehouseProducts(
      GetWarehouseProductsParams(
        jwtToken: currentUser.jwtToken,
        warehouseId: event.warehouseId,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseProductsError(failure.message)),
      (products) => emit(WarehouseProductsLoaded(products)),
    );
  }

  Future<void> _onRefreshWarehouseProducts(
    RefreshWarehouseProductsEvent event,
    Emitter<WarehouseProductsState> emit,
  ) async {
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseProductsError('User not authenticated'));
      return;
    }

    final result = await _getWarehouseProducts(
      GetWarehouseProductsParams(
        jwtToken: currentUser.jwtToken,
        warehouseId: event.warehouseId,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseProductsError(failure.message)),
      (products) => emit(WarehouseProductsLoaded(products)),
    );
  }

  Future<void> _onUpdateWarehouseProduct(
    UpdateWarehouseProductEvent event,
    Emitter<WarehouseProductsState> emit,
  ) async {
    emit(const WarehouseProductOperationLoading());

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseProductsError('User not authenticated'));
      return;
    }

    final result = await _updateWarehouseProduct(
      UpdateWarehouseProductParams(
        jwtToken: currentUser.jwtToken,
        warehouseId: event.warehouseId,
        product: event.product,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseProductsError(failure.message)),
      (_) async {
        emit(const WarehouseProductOperationSuccess(
            'Product updated successfully'));
        add(RefreshWarehouseProductsEvent(event.warehouseId));
      },
    );
  }

  Future<void> _onAddWarehouseProduct(
    AddWarehouseProductEvent event,
    Emitter<WarehouseProductsState> emit,
  ) async {
    emit(const WarehouseProductOperationLoading());

    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseProductsError('User not authenticated'));
      return;
    }
    final result = await _addWarehouseProduct(
      AddWarehouseProductParams(
        jwtToken: currentUser.jwtToken,
        warehouseId: event.warehouseId,
        product: event.product,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseProductsError(failure.message)),
      (_) async {
        emit(const WarehouseProductOperationSuccess(
            'Product added successfully'));
        add(RefreshWarehouseProductsEvent(event.warehouseId));
      },
    );
  }

  Future<void> _onRemoveWarehouseProduct(
    RemoveWarehouseProductEvent event,
    Emitter<WarehouseProductsState> emit,
  ) async {
    emit(const WarehouseProductOperationLoading());
    final currentUser = _userCubit.getCurrentUser();
    if (currentUser == null) {
      emit(const WarehouseProductsError('User not authenticated'));
      return;
    }
    final result = await _removeWarehouseProduct(
      RemoveWarehouseProductParams(
        jwtToken: currentUser.jwtToken,
        warehouseId: event.warehouseId,
        productId: event.productId,
      ),
    );

    result.fold(
      (failure) => emit(WarehouseProductsError(failure.message)),
      (_) {
        emit(const WarehouseProductOperationSuccess(
            'Product removed successfully'));
        add(RefreshWarehouseProductsEvent(event.warehouseId));
      },
    );
  }
}
