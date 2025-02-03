import 'package:flutter/material.dart';

import '../../../../core/common/entities/cart.dart';

class CartDetailScreen extends StatefulWidget {
  final String cartId;

  const CartDetailScreen({super.key, required this.cartId});
  @override
  State<CartDetailScreen> createState() => _CartDetailScreen();
}

class _CartDetailScreen extends State<CartDetailScreen> {
  List<Cart> carts = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart #${widget.cartId}"),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard("Cart #${widget.cartId}", isTitle: true),
              const SizedBox(height: 20),
              _buildInfoCard("Bateria: 35%", icon: Icons.battery_std),
              _buildInfoCard("Destino: Doca 3", icon: Icons.flag),
              _buildInfoCard("Carga: Vazia", icon: Icons.local_shipping),
              _buildInfoCard("Atendimento: 5964",
                  icon: Icons.confirmation_number),
              const Spacer(),
              ElevatedButton(
                onPressed: () =>
                    _showConfirmationDialog("Enviar para Manutenção?"),
                style: _redButtonStyle(context),
                child: const Text("Enviar para Manutenção"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    _showConfirmationDialog("Forçar Desligamento?"),
                style: _redButtonStyle(context),
                child: const Text("Forçar Desligamento"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text, {IconData? icon, bool isTitle = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (icon != null) Icon(icon, size: isTitle ? 30 : 24),
            if (icon != null) const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: isTitle ? 22 : 18,
                fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _redButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red[800],
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  void _showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmação"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Add your action here
              Navigator.pop(context);
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }
}
