// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class MeliAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String labelConfirm;
  final VoidCallback? onConfirm;

  const MeliAlertDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.labelConfirm,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: onConfirm != null
              ? onConfirm
              : () {
                  Navigator.pop(context);
                },
          child: Text(labelConfirm),
        ),
      ],
    );
  }
}
