import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WarehouseDetailsScreen extends StatefulWidget {
  final id;

  const WarehouseDetailsScreen({super.key, this.id});
  @override
  State<WarehouseDetailsScreen> createState() => _WarehouseDetailsScreenState();
}

class _WarehouseDetailsScreenState extends State<WarehouseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse ${widget.id} Details'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Warehouse ${widget.id} Details'),
              ElevatedButton(
                onPressed: () {
                  context.go('/home/warehouses');
                },
                child: const Text('Voltar para a lista de armazéns'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
