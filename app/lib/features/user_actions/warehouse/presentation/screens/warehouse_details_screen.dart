import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
import '../../domain/entities/warehouse_product.dart';
import '../bloc/warehouse_products/warehouse_products_bloc.dart';
import '../bloc/warehouse_products/warehouse_products_event.dart';
import '../bloc/warehouse_products/warehouse_products_state.dart';
import '../widgets/edit_product_dialog.dart';

class WarehouseDetailsScreen extends StatefulWidget {
  final String warehouseId;

  const WarehouseDetailsScreen({
    super.key,
    required this.warehouseId,
  });

  @override
  State<WarehouseDetailsScreen> createState() => _WarehouseDetailsScreenState();
}

class _WarehouseDetailsScreenState extends State<WarehouseDetailsScreen> {
  List<WarehouseProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    context.read<WarehouseProductsBloc>().add(
          GetWarehouseProductsEvent(widget.warehouseId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos dos Armazéns'),
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
            showSnackBar(context, message: state.message, isSucess: true);
          } else if (state is WarehouseProductsError) {
            showSnackBar(context, message: state.message, isError: true);
          } else if (state is WarehouseProductsLoaded) {
            setState(() {
              _products = state.products;
            });
          }
        },
        builder: (context, state) {
          if (state is WarehouseProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WarehouseProductsError) {
            return _buildError(context, state.message);
          }

          if (state is WarehouseProductOperationLoading) {
            return Stack(
              children: [
                _buildProductsList(),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          return _buildProductsList();
        },
      ),
    );
  }

  Widget _buildProductsList() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadProducts();
      },
      child: _products.isEmpty
          ? const Center(
              child: Text('Nenhum Produto Encontrado'),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
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
            onPressed: _loadProducts,
            child: const Text('Tente Novamente'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, WarehouseProduct product) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        warehouseId: widget.warehouseId,
        product: product,
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        warehouseId: widget.warehouseId,
        isNew: true,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WarehouseProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir'),
        content: Text('Você tem certeza que quer excluir ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<WarehouseProductsBloc>().add(
                    RemoveWarehouseProductEvent(
                      warehouseId: widget.warehouseId,
                      productId: product.id,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
