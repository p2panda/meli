// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/confirm_dialog.dart';

class SightingPopupMenu extends StatelessWidget {
  final DocumentViewId viewId;

  const SightingPopupMenu({super.key, required this.viewId});

  void _onTapDelete(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: t.sightingDeleteAlertTitle,
        message: t.sightingDeleteAlertBody,
        labelAbort: t.sightingDeleteAlertCancel,
        labelConfirm: t.sightingDeleteAlertConfirm,
        onConfirm: () async {
          // @TODO: also delete all uses documents and hive location documents.
          await deleteSighting(viewId);
          router.replaceNamed(RoutePaths.allSightings.name);
          messenger.showSnackBar(
              SnackBar(content: Text(t.sightingDeleteConfirmation)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                  child: Text(AppLocalizations.of(context)!.deleteSighting),
                  onTap: () {
                    _onTapDelete(context);
                  }),
            ]);
  }
}
