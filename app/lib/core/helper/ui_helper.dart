import 'package:flutter/material.dart';

class UIHelper {
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
}
