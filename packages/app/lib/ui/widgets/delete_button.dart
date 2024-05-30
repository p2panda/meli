// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/confirm_dialog.dart';

class DeleteSightingButton extends StatelessWidget {
  final DocumentViewId viewId;

  const DeleteSightingButton({super.key, required this.viewId});

  _delete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context)!;

    await deleteSighting(viewId);
    // @TODO: also delete all uses documents and hive location documents.

    router.pushNamed("all_sightings");
    messenger
        .showSnackBar(SnackBar(content: Text(t.sightingDeleteConfirmation)));
  }

  void _confirmDelete(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: t.sightingDeleteAlertTitle,
        message: t.sightingDeleteAlertBody,
        labelAbort: t.sightingDeleteAlertCancel,
        labelConfirm: t.sightingDeleteAlertConfirm,
        onConfirm: () {
          _delete(context);
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
        onPressed: () => _confirmDelete(context),
        child: const Icon(Icons.delete),
      ),
    );
  }
}
