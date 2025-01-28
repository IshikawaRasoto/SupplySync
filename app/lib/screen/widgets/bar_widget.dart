import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget{

	final VoidCallback? onPressed;
	final IconData icon;
	final String leftText;
	final String rightText;

	const BarWidget({
		this.onPressed,
		required this.icon,
		required this.leftText,
		required this.rightText,
	});

  @override
  Widget build(BuildContext context) {
    return 
			ElevatedButton(
				onPressed: onPressed,
				style: ElevatedButton.styleFrom(
					backgroundColor: Colors.transparent,
					shadowColor: Colors.transparent,
				),
				child: Container(
				decoration: BoxDecoration(
					color: Theme.of(context).cardColor,
					borderRadius: BorderRadius.circular(12),
				),
				padding: const EdgeInsets.all(12),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Text(
							leftText,
							style: const TextStyle(
								fontSize: 15,
								fontWeight: FontWeight.bold,
								color: Colors.white,
							),
						),
						Text(
							rightText,
							style: const TextStyle(
								fontSize: 15,
								fontWeight: FontWeight.bold,
								color: Colors.white,
							),
						),
					],
				),
			)
		);
  }
}
