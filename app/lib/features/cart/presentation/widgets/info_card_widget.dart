import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    super.key,
    required this.text,
    this.icon,
    this.isTitle = false,
  });

  final String text;
  final IconData? icon;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
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
}
