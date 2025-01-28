import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:supplysync/helper/ui_helper.dart';

import '../constants/constants.dart';
import '../helper/permission_helper.dart';
import '../models/user.dart';
import 'widgets/logo_and_help_widget.dart';
import 'widgets/bar_widget.dart';

class CartDetailScreen extends StatefulWidget {
	final String cartId;

  const CartDetailScreen({super.key, required this.cartId});
  @override
  State<CartDetailScreen> createState() => _CartDetailScreen();
}

class _CartDetailScreen extends State<CartDetailScreen> {
  late User _user;

  @override
  void initState() {
    _user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				minimum: const EdgeInsets.only(top: 10),
				child: Column(
					children: [
						Center(
							child: Text(
								"Cart #1",
								style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
							)
						)
					],
				),
			),
		);
	}
}

