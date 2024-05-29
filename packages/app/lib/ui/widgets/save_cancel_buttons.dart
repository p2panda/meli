import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveCancel extends StatelessWidget {
  final void Function()? handleSave;
  final void Function()? handleCancel;

  const SaveCancel({super.key, this.handleSave, this.handleCancel});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(children: [
      OverflowBar(
        spacing: 12,
        overflowAlignment: OverflowBarAlignment.start,
        children: [
          FilledButton(
              onPressed: handleSave, child: Text(t.editCardSaveButton)),
          OutlinedButton(
              onPressed: handleCancel, child: Text(t.editCardCancelButton))
        ],
      )
    ]);
  }
}
