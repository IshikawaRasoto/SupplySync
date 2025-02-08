import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
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
    context.read<DockTransportBloc>().add(ResetTransportEvent());
    context.go('/home/docksTransport');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Carrinho'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<CartRequestBloc, CartRequestState>(
        listener: (context, state) {
          if (state is CartRequestFailure) {
            showSnackBar(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is CartRequestInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartRequestCartDetailsFailure) {
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
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          value: (_cart!.battery as int) / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            (_cart!.battery as int) > 20
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nível da Bateria: ${(_cart!.battery as int)}%',
                          style: TextStyle(
                            color: (_cart!.battery as int) > 20
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                                image: NetworkImage(_pickedImage!.path),
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
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Tirar Foto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CartRequestBloc, CartRequestState>(
                  builder: (context, state) {
                    final hasPhoto = context.read<CartRequestBloc>().hasPhoto;
                    return Column(
                      children: [
                        if (!hasPhoto)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Foto obrigatória para liberar o drone',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed: hasPhoto ? _submitAndRelease : null,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Liberar Carrinho'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            disabledBackgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
