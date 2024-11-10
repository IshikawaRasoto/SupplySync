import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WarehousesScreen extends StatefulWidget {
  const WarehousesScreen({super.key});
  @override
  State<WarehousesScreen> createState() => _WarehousesScreenState();
}

class _WarehousesScreenState extends State<WarehousesScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouses'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Warehouses'),
              ElevatedButton(
                onPressed: () {
                  context.go('/home/warehouses/1');
                },
                child: const Text('Ir para o armazém 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/home/warehouses/2');
                },
                child: const Text('Ir para o armazém 2'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/home/warehouses/3');
                },
                child: const Text('Ir para o armazém 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
