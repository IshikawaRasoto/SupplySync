import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  String message = '',
  bool isError = false,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: isError ? const Duration(seconds: 8) : duration,
        backgroundColor: isError ? Colors.red : null,
      ),
    );
}
