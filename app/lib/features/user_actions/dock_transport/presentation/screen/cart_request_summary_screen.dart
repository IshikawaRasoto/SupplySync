import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../cart/domain/entities/cart.dart';
import '../blocs/cart_request_bloc.dart';
import '../blocs/dock_transport_bloc.dart';
import 'package:go_router/go_router.dart';

class CartRequestSummaryScreen extends StatefulWidget {
  final String cartId;

  const CartRequestSummaryScreen({
    super.key,
    required this.cartId,
  });

  @override
  State<CartRequestSummaryScreen> createState() =>
      _CartRequestSummaryScreenState();
}

class _CartRequestSummaryScreenState extends State<CartRequestSummaryScreen> {
  final TextEditingController _problemController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  Cart? _cart;
  bool _showProblemReport = false;

  @override
  void initState() {
    super.initState();
    context
        .read<CartRequestBloc>()
        .add(RequestCartInformationRequested(widget.cartId));
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _pickedImage = photo;
      });
      if (mounted) {
        context.read<CartRequestBloc>().add(CartPhotoSubmitted(photo));
      }
    }
  }

  void _submitAndRelease() {
    final cartBloc = context.read<CartRequestBloc>();
    if (!cartBloc.hasPhoto) {
      showSnackBar(
        context,
        message: 'É necessário tirar uma foto do drone antes de liberá-lo',
        isError: true,
      );
      return;
    }
    context.read<CartRequestBloc>().add(ReleaseCartRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Carrinho'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: 'Relatar Problema',
        onPressed: () {
          setState(() {
            _showProblemReport = !_showProblemReport;
          });
        },
        child: const Icon(Icons.warning, color: Colors.orange),
      ),
      body: BlocConsumer<CartRequestBloc, CartRequestState>(
        listener: (context, state) {
          if (state is CartRequestFailure) {
            showSnackBar(context, message: state.message, isError: true);
          } else if (state is CartReleased) {
            showSnackBar(
              context,
              message: 'Carrinho liberado com sucesso',
              isSucess: true,
            );
            context.read<DockTransportBloc>().add(ResetTransportEvent());
            context.read<CartRequestBloc>().add(ResetCartRequestEvent());
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home/docksTransport');
            }
          } else if (state is CartRequestSuccess) {
            showSnackBar(
              context,
              message: 'Operação realizada com sucesso',
              isSucess: true,
            );
          } else if (state is CartSendProblemSuccess) {
            setState(() {
              _showProblemReport = false;
              _problemController.clear();
            });
          }
        },
        builder: (context, state) {
          final hasPhoto = context.read<CartRequestBloc>().hasPhoto;

          if (state is CartRequestInitial || state is CartRequestInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartRequestFailure) {
            return Center(
                child: Column(
              children: [
                Text('Erro ao carregar detalhes do carrinho'),
                Text(state.message),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<CartRequestBloc>()
                        .add(RequestCartInformationRequested(widget.cartId));
                  },
                  child: const Text('Tentar novamente'),
                ),
              ],
            ));
          } else if (state is CartRequestCartDetailsSuccess) {
            _cart = state.cart;
          } else if (_cart == null) {
            return const Center(child: Text("Cart not found"));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID do Carrinho: ${_cart!.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: int.parse(_cart!.battery) / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          int.parse(_cart!.battery) > 20
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nível da Bateria: ${_cart!.battery}%',
                        style: TextStyle(
                          color: int.parse(_cart!.battery) > 20
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showProblemReport) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Relatar Problema',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _problemController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Descreva o problema encontrado...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_problemController.text.trim().isNotEmpty) {
                              context.read<CartRequestBloc>().add(
                                    CartReportProblemEvent(
                                      _problemController.text,
                                    ),
                                  );
                            } else {
                              showSnackBar(
                                context,
                                message: 'Por favor, descreva o problema',
                                isError: true,
                              );
                            }
                          },
                          icon: const Icon(Icons.send),
                          label: const Text('Enviar Problema'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Foto do Drone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_pickedImage != null)
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_pickedImage!.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text('Nenhuma foto tirada'),
                          ),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: AppColors.white,
                        ),
                        label: const Text('Tirar Foto'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepPurple,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: hasPhoto ? _submitAndRelease : null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Liberar Carrinho'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.all(16),
                    disabledBackgroundColor: AppColors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
