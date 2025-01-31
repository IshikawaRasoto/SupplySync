import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'widgets/bar_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  late User _user;

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart's Info"),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            //LogoAndHelpWidget(logout: true),
            const SizedBox(height: 10),
            Text(
              "Cart's Info",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Container(
									alignment: Alignment.center,
									constraints: BoxConstraints(
										maxHeight: MediaQuery.of(context).size.height * 0.6,
										maxWidth: MediaQuery.of(context).size.width * 0.8,
									),
									decoration: BoxDecoration(
										color: Colors.white,
										borderRadius: BorderRadius.circular(10),
										boxShadow: [
											BoxShadow(
												color: Colors.grey.withOpacity(0.5),
												spreadRadius: 5,
												blurRadius: 7,
												offset: const Offset(0, 3),
											),
										],
									),
									child: ListView.separated(
										padding: const EdgeInsets.all(8),
										itemCount: 3,
										itemBuilder: (context, index) {
											final cartNumber = index + 1;
											return BarWidget(
												icon: Icons.local_shipping,
												leftText: 'Cart $cartNumber',
												rightText: '20%',
												onPressed: () {
													context.go('/home/carts/$cartNumber');
												},
											);
										},
										separatorBuilder: (BuildContext context, int index) => const Divider()
									)
								)
							),
            ),
          ],
        ),
      ),
    );
  }
}
