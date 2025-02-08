import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../../features/cart/domain/entities/cart.dart';
import '../blocs/warehouse_transport_bloc.dart';

class WarehouseTransportScreen extends StatelessWidget {
  const WarehouseTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drones em Chegada'),
        centerTitle: true,
      ),
      body: BlocConsumer<WarehouseTransportBloc, WarehouseTransportState>(
        listener: (context, state) {
          if (state is WarehouseTransportFailure) {
            showSnackBar(context, message: state.error!, isError: true);
          }
        },
        builder: (context, state) {
          if (state is WarehouseTransportInitial) {
            context.read<WarehouseTransportBloc>().add(FetchIncomingDrones());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WarehouseTransportLoading &&
              state.incomingDrones.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WarehouseTransportBloc>().add(FetchIncomingDrones());
            },
            child: _buildDroneList(context, state.incomingDrones),
          );
        },
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
              'Puxe para baixo para atualizar',
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
              // Navigate to drone details screen
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
                  const SizedBox(height: 8),
                  if (drone.load != null) ...[
                    Text(
                      'Carga: ${drone.load}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (drone.destination != null) ...[
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
