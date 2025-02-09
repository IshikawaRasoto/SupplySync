import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/warehouse_product.dart';
import '../bloc/warehouse_products/warehouse_products_bloc.dart';
import '../bloc/warehouse_products/warehouse_products_event.dart';
import '../bloc/warehouse_products/warehouse_products_state.dart';
import '../widgets/edit_product_dialog.dart';

class WarehouseDetailsScreen extends StatelessWidget {
  final String warehouseId;

  const WarehouseDetailsScreen({
    super.key,
    required this.warehouseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<WarehouseProductsBloc, WarehouseProductsState>(
        listener: (context, state) {
          if (state is WarehouseProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is WarehouseProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            WarehouseProductsInitial() => _buildInitial(context),
            WarehouseProductsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            WarehouseProductsLoaded() => _buildLoaded(context, state.products),
            WarehouseProductOperationLoading() => Stack(
                children: [
                  _buildLastState(context),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            WarehouseProductOperationSuccess() => _buildLastState(context),
            WarehouseProductsError() => _buildError(context, state.message),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    context.read<WarehouseProductsBloc>().add(
          GetWarehouseProductsEvent(warehouseId),
        );
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(BuildContext context, List<WarehouseProduct> products) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WarehouseProductsBloc>().add(
              RefreshWarehouseProductsEvent(warehouseId),
            );
      },
      child: products.isEmpty
          ? const Center(
              child: Text('No products found'),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${product.quantity} ${product.unit}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditProductDialog(
                            context,
                            product,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmation(
                            context,
                            product,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildLastState(BuildContext context) {
    return Container(); // The previous state will be shown behind the loading indicator
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<WarehouseProductsBloc>().add(
                    GetWarehouseProductsEvent(warehouseId),
                  );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, WarehouseProduct product) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        warehouseId: warehouseId,
        product: product,
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        warehouseId: warehouseId,
        isNew: true,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WarehouseProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WarehouseProductsBloc>().add(
                    RemoveWarehouseProductEvent(
                      warehouseId: warehouseId,
                      productId: product.id,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
