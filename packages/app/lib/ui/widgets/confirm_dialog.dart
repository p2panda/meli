// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String labelAbort;
  final String labelConfirm;
  final VoidCallback? onAbort;
  final VoidCallback onConfirm;

  const ConfirmDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.labelAbort,
      required this.labelConfirm,
      this.onAbort,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onAbort != null
              ? onAbort
              : () {
                  Navigator.pop(context);
                },
          child: Text(labelAbort),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(labelConfirm),
        ),
      ],
    );
  }
}
