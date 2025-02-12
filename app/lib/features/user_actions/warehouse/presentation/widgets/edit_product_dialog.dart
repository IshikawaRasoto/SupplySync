import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/warehouse_product.dart';
import '../bloc/warehouse_products/warehouse_products_bloc.dart';
import '../bloc/warehouse_products/warehouse_products_event.dart';

class EditProductDialog extends StatefulWidget {
  final String warehouseId;
  final WarehouseProduct? product;
  final bool isNew;

  const EditProductDialog({
    super.key,
    required this.warehouseId,
    this.product,
    this.isNew = false,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController quantityController;
  late final TextEditingController unitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
    quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '0',
    );
    unitController = TextEditingController(text: widget.product?.unit ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    unitController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final quantity = int.tryParse(quantityController.text) ?? 0;

    final product = WarehouseProduct(
      id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      description: descriptionController.text,
      quantity: quantity,
      unit: unitController.text,
    );

    if (widget.isNew) {
      context.read<WarehouseProductsBloc>().add(
            AddWarehouseProductEvent(
              warehouseId: widget.warehouseId,
              product: product,
            ),
          );
    } else {
      context.read<WarehouseProductsBloc>().add(
            UpdateWarehouseProductEvent(
              warehouseId: widget.warehouseId,
              product: product,
            ),
          );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              readOnly: !widget.isNew,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              readOnly: !widget.isNew,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _handleSubmit,
          child: Text(widget.isNew ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
