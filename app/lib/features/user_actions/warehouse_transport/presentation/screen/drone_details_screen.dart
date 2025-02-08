import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../features/cart/domain/entities/cart.dart';
import '../blocs/drone_details_bloc.dart';

class DroneDetailsScreen extends StatelessWidget {
  final String droneId;

  const DroneDetailsScreen({
    super.key,
    required this.droneId,
  });

  Future<void> _takeDronePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null && context.mounted) {
      context.read<DroneDetailsBloc>().add(CaptureDronePhoto(photo: photo));
    }
  }

  Widget _buildDetailsSection(Cart cart) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Drone ${cart.id}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Bateria:', cart.battery),
            if (cart.destination != null)
              _buildInfoRow('Destino:', cart.destination!),
            if (cart.load != null) _buildInfoRow('Carga:', cart.load!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isCompleted,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  color: isCompleted ? Colors.white : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Drone'),
        centerTitle: true,
      ),
      body: BlocConsumer<DroneDetailsBloc, DroneDetailsState>(
        listener: (context, state) {
          if (state is DroneDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is DroneDetailsReleased) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Drone liberado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is DroneDetailsInitial) {
            context
                .read<DroneDetailsBloc>()
                .add(LoadDroneDetails(droneId: droneId));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DroneDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DroneDetailsLoaded) {
            final bloc = context.read<DroneDetailsBloc>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildDetailsSection(state.cart),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Passos para liberação:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStepCard(
                    icon: Icons.flight_land,
                    title: 'Confirmar Chegada',
                    description: 'Confirme que o drone chegou ao armazém',
                    isCompleted: state is DroneDetailsArrivalConfirmed,
                    onTap: () {
                      context
                          .read<DroneDetailsBloc>()
                          .add(ConfirmDroneArrival());
                    },
                  ),
                  _buildStepCard(
                    icon: Icons.camera_alt,
                    title: 'Fotografar Drone',
                    description: 'Tire uma foto do drone vazio',
                    isCompleted: bloc.hasPhoto,
                    onTap: () => _takeDronePhoto(context),
                  ),
                  _buildStepCard(
                    icon: Icons.flight_takeoff,
                    title: 'Liberar Drone',
                    description: 'Libere o drone para retornar ao servidor',
                    isCompleted: state is DroneDetailsReleased,
                    onTap: bloc.hasPhoto
                        ? () {
                            context
                                .read<DroneDetailsBloc>()
                                .add(ReleaseDrone());
                          }
                        : null,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Erro ao carregar detalhes do drone'),
          );
        },
      ),
    );
  }
}
