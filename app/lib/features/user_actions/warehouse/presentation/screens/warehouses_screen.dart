import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/warehouses/warehouses_bloc.dart';
import '../bloc/warehouses/warehouses_event.dart';
import '../bloc/warehouses/warehouses_state.dart';
import '../../domain/entities/warehouse.dart';

class WarehousesScreen extends StatelessWidget {
  const WarehousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouses'),
      ),
      body: BlocBuilder<WarehousesBloc, WarehousesState>(
        builder: (context, state) {
          return switch (state) {
            WarehousesInitial() => _buildInitial(context),
            WarehousesLoading() =>
              const Center(child: CircularProgressIndicator()),
            WarehousesLoaded() => _buildLoaded(context, state.warehouses),
            WarehousesError() => _buildError(context, state.message),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    context.read<WarehousesBloc>().add(const GetWarehousesEvent());
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(BuildContext context, List<Warehouse> warehouses) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<WarehousesBloc>().add(const RefreshWarehousesEvent());
      },
      child: ListView.builder(
        itemCount: warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = warehouses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(warehouse.name),
              subtitle: Text(warehouse.location),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: warehouse.status == 'active'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  warehouse.status,
                  style: TextStyle(
                    color: warehouse.status == 'active'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
              onTap: () {
                // Navigate to warehouse details screen
                context.push('/home/warehouses/${warehouse.id}');
              },
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
            onPressed: () {
              context.read<WarehousesBloc>().add(const GetWarehousesEvent());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
