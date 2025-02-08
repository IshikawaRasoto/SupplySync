import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../blocs/drone_details_bloc.dart';

class DroneDetailsScreen extends StatelessWidget {
  final String droneId;

  const DroneDetailsScreen({Key? key, required this.droneId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DroneDetailsBloc(
        userCubit: context.read(),
        getCartDetails: context.read(),
        uploadDronePhoto: context.read(),
        releaseDrone: context.read(),
      )..add(LoadDroneDetails(droneId: droneId)),
      child: _DroneDetailsView(droneId: droneId),
    );
  }
}

class _DroneDetailsView extends StatelessWidget {
  final String droneId;

  const _DroneDetailsView({Key? key, required this.droneId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drone Details'),
      ),
      body: BlocConsumer<DroneDetailsBloc, DroneDetailsState>(
        listener: (context, state) {
          if (state is DroneDetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DroneDetailsReleased) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Drone released successfully')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is DroneDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DroneDetailsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Drone ID: ${state.cart.id}'),
                  const SizedBox(height: 16),
                  Text('Battery: ${state.cart.battery}'),
                  const SizedBox(height: 16),
                  if (state.cart.load != null) ...[
                    Text('Load: ${state.cart.load}'),
                    const SizedBox(height: 16),
                  ],
                  if (state.cart.destination != null) ...[
                    Text('Destination: ${state.cart.destination}'),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: () => context
                        .read<DroneDetailsBloc>()
                        .add(ConfirmDroneArrival()),
                    child: const Text('Confirm Arrival'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _capturePhoto(context),
                    child: const Text('Capture Photo'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DroneDetailsBloc>()
                        .add(ReleaseDroneEvent(droneId: droneId)),
                    child: const Text('Release Drone'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  Future<void> _capturePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      if (context.mounted) {
        context
            .read<DroneDetailsBloc>()
            .add(CaptureDronePhoto(photo: photo, droneId: droneId));
      }
    }
  }
}
