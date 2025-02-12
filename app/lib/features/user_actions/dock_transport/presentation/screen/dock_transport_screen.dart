import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../blocs/dock_transport_bloc.dart';

class DockTransportScreen extends StatefulWidget {
  const DockTransportScreen({super.key});

  @override
  State<DockTransportScreen> createState() => _DockTransportScreenState();
}

class _DockTransportScreenState extends State<DockTransportScreen>
    with SingleTickerProviderStateMixin {
  Color _borderColor = Colors.transparent;
  late AnimationController _borderController;
  Timer? _borderTimer;
  final TextEditingController _destinationController = TextEditingController();
  Timer? _feedbackTimer;
  final TextEditingController _locationController = TextEditingController();
  MobileScannerController? _scannerController;
  String? _tempFeedback;
  String? _lastCode;

  DockTransportState state = DockTransportInitial();

  @override
  void dispose() {
    _destinationController.dispose();
    _locationController.dispose();
    _borderController.dispose();
    _scannerController?.dispose();
    _feedbackTimer?.cancel();
    _borderTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scannerController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
    );
  }

  void _showTemporaryFeedback(String message, bool isSuccess) {
    setState(() {
      _tempFeedback = message;
      _borderColor = isSuccess ? Colors.green : Colors.red;
    });

    _borderController.forward(from: 0.0);

    _feedbackTimer?.cancel();
    _borderTimer?.cancel();

    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _tempFeedback = null;
        });
      }
    });

    _borderTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.transparent;
        });
      }
    });
  }

  void _handleQRCodeScanned(String code) {
    try {
      if (code == _lastCode) return;
      final currentState = context.read<DockTransportBloc>().state;
      if (!currentState.hasLocation) {
        context
            .read<DockTransportBloc>()
            .add(ScanLocationQRCodeEvent(rawValue: code));
        _lastCode = code;
      } else if (!currentState.hasItem) {
        context
            .read<DockTransportBloc>()
            .add(ScanItemQRCodeEvent(rawValue: code));
        _lastCode = code;
      }
    } catch (e) {
      _showTemporaryFeedback('QR Code inválido', false);
    }
  }

  Widget _buildTemporaryFeedback() {
    final isSuccess = _borderColor == Colors.green;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: _borderColor,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            _tempFeedback ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildScannerOrSuccess(
      BuildContext context, DockTransportState state) {
    if (state is DockTransportSuccess) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 100,
        ),
      );
    }

    return MobileScanner(
      controller: _scannerController!,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          final String? code = barcodes.first.rawValue;
          if (code != null) {
            _handleQRCodeScanned(code);
          }
        }
      },
    );
  }

  Widget _buildInfoContent(BuildContext context, DockTransportState state) {
    if (state is DockTransportSuccess) {
      return const Center(
        child: Text(
          'Transporte solicitado com sucesso!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados do Transporte:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Local Atual:'),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Escaneie ou digite o local',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                    if (value.isNotEmpty) {
                      context.read<DockTransportBloc>().add(
                            UpdateLocationManuallyEvent(location: value),
                          );
                      print('Cachorro teste 1');
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () {
                  _locationController.clear();
                  _lastCode = null;
                  context
                      .read<DockTransportBloc>()
                      .add(ResetTransportLocationEvent());
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Informações do Item
          Text(
            'Item: ${state.item ?? "Não escaneado"}',
            style: TextStyle(
              color: state.item != null ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            'Quantidade: ${state.quantity ?? "Não escaneado"}',
            style: TextStyle(
              color: state.quantity != null ? Colors.black : Colors.grey,
            ),
          ),
          if (state.hasItem)
            Row(
              children: [
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    _lastCode = null;

                    context
                        .read<DockTransportBloc>()
                        .add(ResetTransportItemEvent());
                    _destinationController.clear();
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Re-escanear Item'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Destino
          if (state.hasItem) ...[
            const Text('Destino:'),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(
                hintText: 'Digite o destino',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<DockTransportBloc>().add(
                        UpdateDestinationEvent(destination: value),
                      );
                }
              },
            ),
          ],
          const SizedBox(height: 16),
          Center(child: _buildInstructions(state)),
        ],
      ),
    );
  }

  Widget _buildInstructions(DockTransportState state) {
    if (!state.hasLocation) {
      return const Text(
        'Defina seu local atual para continuar',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );
    }

    if (!state.hasItem) {
      return const Text(
        'Agora escaneie o QR Code do item',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );
    }

    if (state.destination == null || state.destination!.isEmpty) {
      return const Text(
        'Digite o destino para continuar',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );
    }

    return Container();
  }

  Widget _buildActionButtons(BuildContext context, DockTransportState state) {
    if (state is DockTransportSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () =>
                context.push('/home/docksTransport/${state.cartId}'),
            icon: const Icon(Icons.local_shipping, color: Colors.white),
            label: const Text(
              'Acompanhar Transporte',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              _destinationController.clear();
              _locationController.clear();
              _lastCode = null;

              context.read<DockTransportBloc>().add(ResetTransportEvent());
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Novo Transporte',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    }

    if (state.hasAllInfo) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () => context.read<DockTransportBloc>().add(
              DockTransportRequested(
                item: state.item!,
                quantity: state.quantity!,
                origin: state.location!,
                destination: state.destination!,
              ),
            ),
        icon: const Icon(Icons.local_shipping),
        label: const Text(
          'Chamar Drone',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _destinationController.clear();
              _locationController.clear();
              _lastCode = null;
              context.read<DockTransportBloc>().add(ResetTransportEvent());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<DockTransportBloc, DockTransportState>(
            listener: (context, state) {
              if (state is DockTransportFailure) {
                _showTemporaryFeedback(state.error, false);
              } else if (state is DockTransportSuccess) {
                _showTemporaryFeedback(
                    'Transporte solicitado com sucesso!', true);
                context.push('/home/docksTransport/${state.cartId}');
              } else if (state is DockTransportQrCodeReaded) {
                _showTemporaryFeedback('Informações atualizadas', true);
              }
            },
            builder: (context, state) {
              if (state.location != null &&
                  state.location != _locationController.text) {
                _locationController.text = state.location!;
              }
              if (state.destination != null &&
                  state.destination != _destinationController.text) {
                _destinationController.text = state.destination!;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!state.hasAllInfo) ...[
                    Expanded(
                      flex: 2,
                      child: AnimatedBuilder(
                        animation: _borderController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _borderColor,
                                width: 4.0 * _borderController.value,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: _buildScannerOrSuccess(context, state),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: _buildInfoContent(context, state),
                          ),
                          if (_tempFeedback != null)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _buildTemporaryFeedback(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
