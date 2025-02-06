import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dock_transport_bloc.dart';

class DockTransportScreen extends StatelessWidget {
  const DockTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digitalizar QR Code'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DockTransportBloc, DockTransportState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: state is DockTransportLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepPurple),
                              )
                            : Icon(
                                Icons.qr_code_scanner,
                                color: Colors.deepPurple,
                                size: 100,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Information card
                  Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildInfoContent(state),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action button to simulate QR scan or re-scan
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => context.read<DockTransportBloc>().add(
                          DockTransportRequested(
                            item: 'Apples',
                            quantity: 25,
                            origin: 'Dock 5',
                            destination: 'Warehouse 3',
                          ),
                        ),
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      state is DockTransportInitial
                          ? 'Escanear QR Code'
                          : 'Re-escaneie para atualizar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContent(DockTransportState state) {
    if (state is DockTransportInitial) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Aponte sua câmera para um código QR para obter os dados da caixa.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            'Informações como item, quantidade e destino serão reveladas.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
    } else if (state is DockTransportSuccess) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 8),
            Text(
              'Transporte solicitado com sucesso!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    } else if (state is DockTransportFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Falha ao solicitar transporte.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
