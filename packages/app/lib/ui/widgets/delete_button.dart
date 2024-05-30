// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/confirm_dialog.dart';

class DeleteButton extends StatelessWidget {
  final Function onDelete;

  const DeleteButton({super.key, required this.onDelete});

  void _delete(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: t.imageDeleteAlertTitle,
        message: t.imageDeleteAlertBody,
        labelAbort: t.imageDeleteAlertCancel,
        labelConfirm: t.imageDeleteAlertConfirm,
        onConfirm: () {
          onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: const BorderSide(width: 3.0, color: MeliColors.plum),
            foregroundColor: MeliColors.plum),
        onPressed: () => _delete(context),
        child: const Icon(Icons.delete),
      ),
    );
  }
}
