import 'package:flutter/material.dart';

Future<bool?> showDialogConfirmation(BuildContext context,
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
