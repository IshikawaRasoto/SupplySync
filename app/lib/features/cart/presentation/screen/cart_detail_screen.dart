import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/show_confimation_dialog.dart';
import '../../domain/entities/cart.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/info_card_widget.dart';

class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({super.key, required this.cartId});
  final String cartId;
  @override
  State<CartDetailScreen> createState() => _CartDetailScreen();
}

class _CartDetailScreen extends State<CartDetailScreen> {
  Cart? cart;

  @override
  void initState() {
    context.read<CartBloc>().add(CartDetailsRequested(widget.cartId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart #${widget.cartId}"),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartRequestSuccess) {
            showSnackBar(
              context,
              message: "Request Success",
              isSucess: true,
            );
          } else if (state is CartRequestFailure) {
            showSnackBar(context, message: state.failure, isError: true);
          } else if (state is CartDetailsSuccess) {
            cart = state.cart;
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartRequestFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.failure}"),
                  ElevatedButton(
                    onPressed: () => context
                        .read<CartBloc>()
                        .add(CartDetailsRequested(widget.cartId)),
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          } else if (cart == null) {
            return const Center(child: Text("Cart not found"));
          }
          return SafeArea(
            minimum: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoCardWidget(text: "Cart #${cart!.id}", isTitle: true),
                  const SizedBox(height: 20),
                  InfoCardWidget(
                    text: "Bateria: ${cart!.battery}%",
                    icon: Icons.battery_std,
                  ),
                  InfoCardWidget(
                    text: "Destino: ${cart!.destination}",
                    icon: Icons.flag,
                  ),
                  InfoCardWidget(
                    text: "Origin: ${cart!.origin}",
                    icon: Icons.flag,
                  ),
                  InfoCardWidget(
                    text: "Carga: ${cart!.load}",
                    icon: Icons.local_shipping,
                  ),
                  InfoCardWidget(
                    text: "Status: ${cart!.status}",
                    icon: Icons.info,
                  ),
                  const Spacer(),
                  if (cart!.status != 'manutencao')
                    ElevatedButton(
                      onPressed: () => showDialogConfirmation(
                        context,
                        title: "Enviar para Manutenção?",
                        onConfirm: () => context
                            .read<CartBloc>()
                            .add(CartMaintenanceRequested(cart!.id)),
                      ),
                      style: AppStyles.redButtonStyle,
                      child: const Text("Enviar para Manutenção"),
                    ),
                  if (cart!.status == 'manutencao')
                    ElevatedButton(
                      onPressed: () => showDialogConfirmation(
                        context,
                        title: "Liberar da Manutenção",
                        onConfirm: () => context
                            .read<CartBloc>()
                            .add(CartMaintenanceRequested(cart!.id)),
                      ),
                      style: AppStyles.redButtonStyle,
                      child: const Text("Liberar da Manutenção"),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => showDialogConfirmation(context,
                        title: "Forçar Desligamento?",
                        onConfirm: () => context
                            .read<CartBloc>()
                            .add(CartShutdownRequested(cart!.id))),
                    style: AppStyles.redButtonStyle,
                    child: const Text("Forçar Desligamento"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
