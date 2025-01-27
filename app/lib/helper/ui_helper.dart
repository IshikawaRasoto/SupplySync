import 'package:flutter/material.dart';

class UIHelper {
  static showSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        showCloseIcon: true,
        content: Text(message),
      ),
    );
  }

  static showErrorSnackBar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 6)}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static Future<bool?> showDialogConfirmation(BuildContext context,
      {String title = '', String message = '', Function? onConfirm}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                onConfirm?.call();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  static Widget buttonIconAndTextWidget(
      BuildContext context, IconData icon, String text, Function() onPressed) {
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
              onPressed: () => onPressed(),
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

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
