import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../features/cart/domain/entities/cart.dart';
import '../../../../../features/user_actions/warehouse/domain/entities/warehouse.dart';
import '../blocs/warehouse_transport_bloc.dart';

class WarehouseTransportScreen extends StatefulWidget {
  const WarehouseTransportScreen({super.key});

  @override
  State<WarehouseTransportScreen> createState() =>
      _WarehouseTransportScreenState();
}

class _WarehouseTransportScreenState extends State<WarehouseTransportScreen> {
  Warehouse? _selectedWarehouse;
  List<Warehouse> _warehouses = [];

  @override
  void initState() {
    super.initState();
    context.read<WarehouseTransportBloc>().add(const FetchWarehousesEvent());
  }

  void _fetchDrones() {
    if (_selectedWarehouse != null) {
      context.read<WarehouseTransportBloc>().add(
            FetchIncomingDronesEvent(location: _selectedWarehouse!.name),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drones em Chegada'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<WarehouseTransportBloc,
                      WarehouseTransportState>(
                    builder: (context, state) {
                      if (state is WarehouseTransportSuccess) {
                        _warehouses = state.warehouses;
                      }
                      return DropdownButtonFormField<Warehouse>(
                        decoration: const InputDecoration(
                          labelText: 'Armazém',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedWarehouse,
                        items: _warehouses.map((warehouse) {
                          return DropdownMenuItem(
                            value: warehouse,
                            child: Text(warehouse.name),
                          );
                        }).toList(),
                        onChanged: (Warehouse? value) {
                          setState(() {
                            _selectedWarehouse = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectedWarehouse != null ? _fetchDrones : null,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                BlocConsumer<WarehouseTransportBloc, WarehouseTransportState>(
              listener: (context, state) {
                if (state is WarehouseTransportFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error ?? 'Ocorreu um erro'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is WarehouseTransportLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is WarehouseTransportSuccess) {
                  return _buildDroneList(context, state.incomingDrones);
                }

                return Center(
                  child: Text(
                    'Digite seu local e clique em buscar',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDroneList(BuildContext context, List<Cart> drones) {
    if (drones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flight_land,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum drone a caminho',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tente outro local',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: drones.length,
      itemBuilder: (context, index) {
        final drone = drones[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              context.go('/home/warehouseTransport/${drone.id}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Drone ${drone.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.battery_charging_full,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              drone.battery,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (drone.load != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Carga: ${drone.load}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  if (drone.destination != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Destino: ${drone.destination}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Toque para ver detalhes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
