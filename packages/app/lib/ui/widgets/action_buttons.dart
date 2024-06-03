// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onAction;
  final VoidCallback? onCancel;
  final String? cancelLabel;
  final String? actionLabel;

  const ActionButtons(
      {super.key,
      this.onAction,
      this.onCancel,
      this.cancelLabel,
      this.actionLabel});

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
            onPressed: onAction,
            child: Text(actionLabel ?? t.actionDefaultButton),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(width: 3.0, color: MeliColors.plum),
                  foregroundColor: MeliColors.plum),
              onPressed: onCancel,
              child: Text(
                cancelLabel ?? t.actionCancelButton,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      )
    ]);
  }
}
