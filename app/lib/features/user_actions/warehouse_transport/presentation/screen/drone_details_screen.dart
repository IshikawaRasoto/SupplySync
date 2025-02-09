import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../cart/domain/entities/cart.dart';
import '../blocs/drone_details_bloc.dart';

class DroneDetailsScreen extends StatefulWidget {
  final String droneId;

  const DroneDetailsScreen({super.key, required this.droneId});

  @override
  State<DroneDetailsScreen> createState() => _DroneDetailsScreenState();
}

class _DroneDetailsScreenState extends State<DroneDetailsScreen> {
  Cart? _cart;

  @override
  void initState() {
    super.initState();
    context
        .read<DroneDetailsBloc>()
        .add(LoadDroneDetails(droneId: widget.droneId));
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
            showSnackBar(context, message: state.message, isError: true);
          } else if (state is DroneDetailsReleased) {
            showSnackBar(context, message: 'Drone released');
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is DroneDetailsLoading || state is DroneDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DroneDetailsLoaded) {
            _cart = state.cart;
          } else if (_cart == null) {
            return Center(
                child: Column(
              children: [
                const Text('Drone not found'),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back'),
                ),
              ],
            ));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Drone ${_cart!.id}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
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
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _cart!.battery,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (_cart!.load != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.inventory_2,
                                  color: Colors.deepPurple, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Carga:',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _cart!.load!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_cart!.destination != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.deepPurple, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Destino:',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _cart!.destination!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<DroneDetailsBloc>()
                              .add(ConfirmDroneArrival()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle,
                              color: Colors.green),
                          label: const Text(
                            'Confirmar Chegada',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: context.read<DroneDetailsBloc>().hasArrived
                              ? _capturePhoto
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text(
                            'Capturar Foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: context.read<DroneDetailsBloc>().hasPhoto
                              ? _releaseDrone
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Liberar Drone',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _releaseDrone() {
    return context
        .read<DroneDetailsBloc>()
        .add(ReleaseDroneEvent(droneId: widget.droneId));
  }

  Future<void> _capturePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      if (mounted) {
        context
            .read<DroneDetailsBloc>()
            .add(CaptureDronePhoto(photo: photo, droneId: widget.droneId));
      }
    }
  }
}
