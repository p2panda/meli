// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/species.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/confirm_dialog.dart';
import 'package:app/ui/widgets/refresh_provider.dart';

class SpeciesPopupMenu extends StatelessWidget {
  final Species species;

  const SpeciesPopupMenu({super.key, required this.species});

  void _onDelete(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context)!;
    final refreshProvider = RefreshProvider.of(context);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: t.speciesDeleteAlertTitle,
        message: t.speciesDeleteAlertBody,
        labelAbort: t.speciesDeleteAlertCancel,
        labelConfirm: t.speciesDeleteAlertConfirm,
        onConfirm: () async {
          await species.delete();

          // Set flag for other widgets to tell them that they might need to
          // re-render their data. This will make sure that our updates are
          // reflected in the UI
          refreshProvider.setDirty(RefreshKeys.DeletedSpecies);

          // First pop closes this dialog, second goes back to the view we came
          // from
          router.pop();
          router.pop();

          messenger.showSnackBar(
              SnackBar(content: Text(t.speciesDeleteConfirmation)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return PopupMenuButton(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem<void>(
                  child: Text(t.deleteSpecies),
                  onTap: () {
                    _onDelete(context);
                  }),
            ]);
  }
}
