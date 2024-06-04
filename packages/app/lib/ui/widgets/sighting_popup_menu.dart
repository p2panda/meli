// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/files.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/confirm_dialog.dart';
import 'package:app/ui/widgets/refresh_provider.dart';

class SightingPopupMenu extends StatelessWidget {
  final Sighting sighting;

  const SightingPopupMenu({super.key, required this.sighting});

  void _onExportImages(BuildContext context) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      await downloadAndExportImages(
          sighting.images.map((blob) {
            return blob.id;
          }).toList(),
          selectedDirectory!);
    }
  }

  void _onDelete(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context)!;
    final refreshProvider = RefreshProvider.of(context);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmDialog(
        title: t.sightingDeleteAlertTitle,
        message: t.sightingDeleteAlertBody,
        labelAbort: t.sightingDeleteAlertCancel,
        labelConfirm: t.sightingDeleteAlertConfirm,
        onConfirm: () async {
          await sighting.delete();

          // Set flag for other widgets to tell them that they might need to
          // re-render their data. This will make sure that our updates are
          // reflected in the UI
          refreshProvider.setDirty(RefreshKeys.DeletedSighting);

          // First pop closes this dialog, second goes back to the view we came
          // from
          router.pop();
          router.pop();

          messenger.showSnackBar(
              SnackBar(content: Text(t.sightingDeleteConfirmation)));
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
                  child: Text(t.exportImages),
                  onTap: () {
                    _onExportImages(context);
                  }),
              PopupMenuItem<void>(
                  child: Text(t.deleteSighting),
                  onTap: () {
                    _onDelete(context);
                  }),
            ]);
  }
}
