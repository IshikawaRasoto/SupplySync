import 'package:flutter/material.dart';

class ServicesPagesWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const ServicesPagesWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(12),
            child: IconButton(
              onPressed: onPressed,
              icon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
