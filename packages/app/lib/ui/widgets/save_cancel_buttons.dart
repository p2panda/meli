// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';

class SaveCancel extends StatelessWidget {
  final void Function()? handleSave;
  final void Function()? handleCancel;

  const SaveCancel({super.key, this.handleSave, this.handleCancel});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(children: [
      OverflowBar(
        spacing: 10,
        overflowAlignment: OverflowBarAlignment.start,
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                foregroundColor: MeliColors.white,
                backgroundColor: MeliColors.plum),
            onPressed: handleSave,
            child: Text(t.editCardSaveButton),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(width: 3.0, color: MeliColors.plum),
                  foregroundColor: MeliColors.plum),
              onPressed: handleCancel,
              child: Text(
                t.editCardCancelButton,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      )
    ]);
  }
}
